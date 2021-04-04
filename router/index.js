const express = require("express")
const fs = require("fs")
const mongoc = require("../model/connect")
const { getRandomCeleb, insertStaleGameReference,
  createNewGameID,updateGameResultsWithID,
  updateStaleSurveyAsFulfilled, fetchSurveysInRange,
  getCelebImgUrlsFromSurveys, findNotificationById,
  createScheduledNotification, readAllScheduledNotifications,
deleteNotification,} = require("../model")

const  {postNotificationToDevice} = require("../model/FCMdao")
const { GameSurveyMongo, BreedMap} = require("../model/schema")
module.exports = express()
//* a comment*/

module.exports.get("/game/new", function(req,res){
  var response = {
    "votes": [0,1,2]
  }
  getRandomCeleb()
  .then(function(celebs){
    response.celebs = celebs
    return new Promise((resolve,reject) => {
      createNewGameID(celebs,resolve,reject)
    })
  })
  .then(function(gameid){
    console.log(gameid);
    response._id = gameid
    return insertStaleGameReference(gameid)
  })
  .then(function(){
    res.status(201).json(response)
  })
  .catch(function(topleevel){
    console.log("TOPCATCH: ", topleevel)
    res.status(400).send()
  })
})

module.exports.get("/game",function(req,res,next){
  const {where,offset,limit} = req.query
  fetchSurveysInRange(parseInt(where),parseInt(offset),parseInt(limit))
  .then(function(surveys){
    return getCelebImgUrlsFromSurveys(surveys)
  })
  .then(function(aggregated){
    res.status(200).send(aggregated)
  })
  .catch(function(err){
    print(err)
    res.status(300).end()
  })

})


module.exports.post("/game/:gameid", function(req,res){
  let gameid = req.params.gameid
  const json = req.body
  if(!gameid){
    res.status(500).send("Request invalid")
    return
  }

  let game = new GameSurveyMongo(json)

  updateGameResultsWithID(gameid,game)
  .then(function(){
    return updateStaleSurveyAsFulfilled(gameid)
  })
  .then(function(){
    res.status(200).end()
  })
  .catch(function(err){
    res.status(300).send("error updateing ",gameid)
  })

})





module.exports.post("/notifications/schedule",function(req,res){
  const { deviceid , breed } = req.query
  createScheduledNotification({ vapid: deviceid, breed})
  .then(function(success){
    res.status(201).end()
  })
  .catch(function(err){
    console.log(err);
    res.status(422).end()
  })

})

module.exports.post("/notifications/dispatch",function(req,res){
  readAllScheduledNotifications()
  .then(function(cursor){
    cursor.forEach(function(val){
      if(val.device_token && val.suggested_kitty){
        postNotificationToDevice({
          vapid: val.device_token,
           breed: val.suggested_kitty,
          nid: val._id
        })
        .then(function(){return})
        .catch(function(e){
          console.log("could not send notification",val);
        })
      }

    })
    res.status(200).end()
  })
  .catch(function(err){
    console.log(err);
    res.status(300).end()
  })
})

module.exports.delete("/notifications",function(req,res){
  const {adoption_status,notification_id} = req.query
  findNotificationById(notification_id)
  .then(function(doc){
    if(!doc){
      throw "The document is no exist"
    }
    if(!doc.suggested_kitty){
      return deleteNotification(notification_id)
    }
    return new Promise(function(resolve,reject){
      fs.readFile("../stats/AdoptionRatesByBreed.json",function(data,err){
        resolve({
          json: JSON.parse(data),
          suggested_kitty: doc.suggested_kitty,
        })
      })
    })
  })
  .then(function({json,suggested_kitty}){
    const fullname = BreedMap[suggested_kitty]
    if(json[fullname]){
      json[fullname] += 1
    }else{
      json[fullname] = 1
    }
    return new Promise(function(resolve,reject){
      fs.writeFile("../stats/AdoptionRatesByBreed.json",JSON.stringify(json),function(error){
        if(err){
          reject(err)
        }
        else{
          resolve()
        }
      })
    })
  })
  .then(function(){
    return deleteNotification(notification_id)
  })
  .then(function(){
    res.status(200).end()
  })
  .catch(function(e){
    console.log(e);
    res.status(300).end()
  })


})
