const express = require("express")
const mongoc = require("../model/connect")
const { getRandomCeleb, createNewGameID } = require("../model")
module.exports = express()


module.exports.get("/game/new", function(req,res){
  var response = {

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
    response.gameid = gameid
    res.status(201).json(response)
  })
  .catch(function(topleevel){
    console.log("TOPCATCH: ", topleevel)
    res.status(400).send()
  })
})


module.exports.post("/game/:gameid", function(req,res){
  let gameid = req.params.gameid
  console.log(req.body);
  res.status(200).send()


})

module.exports.post("/game")
