const mongoc = require("./connect.js")
const {Celeb,GameSurveyMongo,GameSurveySwift,StaleSurveyReference} = require("./schema.js")
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
      mongoc.db(MONGO_DB_NAME).collection("celebs")
      .insertOne(celeb,function(err){
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

/**
 * Returns promise creating a new item in the stale collection, which is used to
 * delete any unfilfilled surveys every morning,
 *
 * @param {ObjectId}  The recently created game survey Id.
 */
function insertStaleGameReference(gameid){
  const db = mongoc.db()
  return new Promise(function(resolve,reject){
    const doc = new StaleSurveyReference(gameid)
    db.collection("stale-surveys")
    .insertOne(doc)
    .then(function(status){
      resolve()
    })
    .catch(function(err){
      reject(err)
    })
  })
}

/* read */
function mapStaleGames(){
  const db = mongoc.db()
  return new Promise(async function(resolve,reject){
    let results = await db.collection("stale-surveys").find({})
    let mappedids = {
      references: [],
      ids: []
    }
    await results.forEach(function(result){
      mappedids.references.push(
        result.reference
      )
      mappedids.ids.push(result._id)
    })
    resolve(mappedids)
  })
}

/* update */

/**
 * Returns promise after updating a new game result,
 *
 * @param {ObjectId}  The recently created game survey Id.
 * @param {GameSurveyMongo} The previous document with a,b and c modified.
 */
function updateGameResultsWithID(gameid,game){
  const db = mongoc.db()


  return new Promise(async function(resolve,reject){

      if( game.constructor.name == "GameSurveyMongo" ){
        const {actiona, actionb,actionc } = game
        db
          .collection("gamesurveys")
          .updateOne(
            { "_id": ObjectId(gameid)},
            { "$set": {actiona,actionb,actionc} }
          )
          .then(function(status){
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

function updateStaleSurveyAsFulfilled(gameid){
  const db = mongoc.db()
  return new Promise(function(resolve,reject){
    db.collection("stale-surveys")
    .deleteOne({
      "reference": ObjectId(gameid)
    })
    .then(function(status){
      resolve()
    })
    .catch(function(err){
      reject(err)
    })
  })
}

function bulk_deleteExpiredGames(gameids){
  const db = mongoc.db()
  return new Promise(function(resolve,reject){
    db.collection("gamesurveys")
    .deleteMany({
      "_id": { "$in" : gameids }
    })
    .then(function(status){
      resolve(status.deletedCount)
    })
    .catch(function(err){
      reject(err)
    })
  })
}

function bulk_rinseStaleCollection(ids){
  const db = mongoc.db()
  return new Promise(function(resolve,reject){
    db.collection("stale-surveys")
    .deleteMany({
      "_id": { "$in" : ids }
    })
    .then(function(status){
      resolve(status.deletedCount)
    })
    .catch(function(err){
      reject(err)
    })
  })
}






module.exports = {
  mapStaleGames,
  getRandomCeleb,
  WARNING_bulkwrite_kitties,
  createNewGameID,
  updateGameResultsWithID,
  insertCeleb,
  bulk_deleteExpiredGames,
  bulk_rinseStaleCollection,
  updateStaleSurveyAsFulfilled,
  insertStaleGameReference,

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
