const express = require("express")
const mongoc = require("../model/connect")
const { getRandomCeleb, insertStaleGameReference,
  createNewGameID,updateGameResultsWithID,
  updateStaleSurveyAsFulfilled,
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
