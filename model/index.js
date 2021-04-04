const mongoc = require("./connect.js")
const {Celeb,KMKFutureNotification,
  GameSurveyMongo,GameSurveySwift,
  StaleSurveyReference,MongoCollectionSurvey} = require("./schema.js")
const {ObjectId} = require("mongodb")
const {MONGO_DB_NAME} = require("./configureEnv")

const SURVEYS = "gamesurveys"
const CELEBS = "celebs"
const STALE = "stale-surveys"
const NTFCNS = "future-kitty-pushes"


/* Crud operations */


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
 * Creates inventory record which has the information to push
 * to an ios device. this information is accessed reguarly
 * and the nthe sever sends notification at that time
 *
 * @param {Int}  the type of game we would like to retrieve
 * @param {Int} the offset of results we would like to skip
 * @param {Int} the limit of results to find
 *
 * @return {Promise}
 */
function createScheduledNotification({ vapid, breed}){
  const ScheduledNotification = new KMKFutureNotification( vapid, breed)

  return mongoc.db(MONGO_DB_NAME).collection(NTFCNS)
        .insertOne(ScheduledNotification)
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



//-------------------------------------------
//-------------------------------------------

/* read */

function findNotificationById(id){
  return new Promise(async function(resolve,reject){

      let cursor = await mongoc.db(MONGO_DB_NAME)
      .collection(NTFCNS)
      .findOne({ "_id": new ObjectId(id) })
      resolve(cursor)
    })
}

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


function readAllScheduledNotifications(){
  return new Promise(async function(resolve,reject){
    let unsent = []
    const cursor = await mongoc.db(MONGO_DB_NAME)
    .collection(NTFCNS)
    .find({})
    resolve(cursor)
    resolve(unsent)
  })
}
/**
 * Returns promise with an array of games in the specified range and type,
 *
 * @param {Int}  the type of game we would like to retrieve
 * @param {Int} the offset of results we would like to skip
 * @param {Int} the limit of results to find
 *
 * @return {Promise}
 */
function fetchSurveysInRange(type,offset,limit){
  const db = mongoc.db()

  return new Promise(async function(resolve,reject){
    let scrambeled = []
    const cursor = await db.collection(SURVEYS).find({}).skip(offset).limit(limit)
    await cursor.forEach(function(val){
      scrambeled.push(val)
    })
    resolve(scrambeled)

  })
}
/**
 * Returns promise that reduces to a dictionary.
 *
 * @param {[String]}  the celebrities to lookup and map to imgurls
 */
function getCelebImgUrlsFromSurveys(surveys){
  const db = mongoc.db()
  const cids = surveys.map(function(survey){
    return survey.celebs
  }).flat()
  const query = {
    "_id": { "$in": cids }
  }
  const response  = {
    surveys,
    "dict": new Map()
  }
  return new Promise(async function(resolve,reject){
     let cursor = db.collection(CELEBS).find(query)
     await cursor.forEach(function(doc){
       response["dict"][`${doc._id}`] = doc.imgurl
     })
     resolve(response)
  })
}

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



//-------------------------------------------
//-------------------------------------------

/* delete */

function deleteNotification(id){
  return mongoc.db(MONGO_DB_NAME)
  .collection(NTFCNS)
  .deleteOne({ "_id": new ObjectId(id)})
}
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
  deleteNotification,
  mapStaleGames, readAllScheduledNotifications,
  getRandomCeleb, createScheduledNotification,
  WARNING_bulkwrite_kitties,
  createNewGameID,
  updateGameResultsWithID,
  insertCeleb, findNotificationById,
  bulk_deleteExpiredGames,
  bulk_rinseStaleCollection,
  updateStaleSurveyAsFulfilled,
  insertStaleGameReference,
  fetchSurveysInRange,
  getCelebImgUrlsFromSurveys

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
