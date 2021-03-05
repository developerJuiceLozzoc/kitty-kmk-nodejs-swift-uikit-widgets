const mongoc = require("./connect.js")
const {Celeb,GameSurveyMongo,GameSurveySwift} = require("./schema.js")
const {ObjectId} = require("mongodb")
const {MONGO_DB_NAME} = require("./configureEnv")

/* Crud operations */
/* Read, random, */
function getRandomCeleb(){
  let celebs = mongoc.db(MONGO_DB_NAME).collection("celebs")
  return new Promise( function(resolve,reject){
    celebs.aggregate([
        {
          '$match': {}
        }, {
          '$sample': {
            'size': 3
          }
        }
      ], async function(err, entity) {
            if(err){
              reject(err)
              return;
            }
            else{
              var celebs  = []
              await entity.forEach(function(val){
                celebs.push(val)
              })
              resolve(
                celebs
              )
            }
          }
        )
  })

}

//-------------------------------------------
//-------------------------------------------


/* Create */

async function createNewGameID(celebs,resolve,reject){
  const celebids = celebs.map(function(val,index){
    return val._id
  })
  const game = new GameSurveyMongo(celebids)
  try {
    let stuff = await mongoc
                      .db(MONGO_DB_NAME)
                      .collection("gamesurveys")
                      .insertOne(game)
    resolve(stuff.insertedId)
  }
  catch(e){
    reject(e)
  }

}


function insertCeleb(celeb,callback){
  if(celeb.constructor.name == "Celeb"){
      mongoc.db(MONGO_DB_NAME).collection("celebs").insertOne(celeb,function(err){
      if(err){
        callback(err)
      }
      else{
        callback(null)
      }
    })
  }
  else{
    return callback("The passed object was of the wrong type.")
  }
}


/* update */

/**
 * Returns promise after updating a new game result,
 *
 * @param {ObjectId}  The recently created game survey Id.
 * @param {GameSurveyMongo} The previous document with a,b and c modified.
 */
function updateGameResultsWithID(gameid,game){
  const db = mongodb.db()


  return new Promise(async function(resolve,reject){

      if( game.constructor.name == "GameSurveyMongo" ){
        db
          .collection("gamesurveys")
          .updateOne(
            { "_id": ObjectId(gameid)},
            { "result": game.result }
          )
          .then(function(status){
            console.log(status);
            resolve()
          })
          .catch(function(e){
            reject(e)
          })
      }
      else{
        reject("You cannot save this document unles its this file.")
      }

  })


}



/* delete */

function deleteExpiredGame(gameid,callback){

}




module.exports = {
  getRandomCeleb,
  WARNING_bulkwrite_kitties,
  createNewGameID,
  updateGameResultsWithID,
  insertCeleb,
}

function WARNING_bulkwrite_kitties(){
  var count = 0
  var interval = setInterval(
    function() {
      var width = Math.floor(Math.random()*41)*25
      var height = Math.floor(Math.random()*41)*25
      const kitty = new Celeb(`${width}x${height}`,`https://placekitten.com/${700+count}/1334`)
      insertCeleb(kitty,function(){})
      if(count > 100){
        clearInterval(interval)
      }



      count += 1
    }
    ,500);
}

/*
manually type in the url

const mongoconnect = require("./model/connect")
const  {insertCeleb} = require("./model")
const {Celeb} = require("./model/schema")
var url = "https://i.imgur.com/82SIHDx.jpeg"
 var kitty = new Celeb(url)
 mongoconnect.connect((err,client) => {
   if(err) {
     console.log(err);
   }
   else{
   insertCeleb(kitty,function(err){
      if(err){
      console.log(err);
      }
      client.close();
    })
   }

 });


*/
