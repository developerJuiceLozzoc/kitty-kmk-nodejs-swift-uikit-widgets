const express = require("express")
const mongoc = require("../model/connect")
const { getRandomCeleb, insertStaleGameReference,
  createNewGameID,updateGameResultsWithID,
  updateStaleSurveyAsFulfilled, fetchSurveysInRange,
  getCelebImgUrlsFromSurveys,
 } = require("../model")
const { GameSurveyMongo} = require("../model/schema")
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
