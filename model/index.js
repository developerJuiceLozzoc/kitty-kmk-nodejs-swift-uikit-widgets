const mongoc = require("./connect.js")
const {Celeb,GameSurvey} = require("./schema.js")

/* Crud operations */
/* Read, random, */
function getRandomCeleb(){
  let celebs = mongoc.db("marry-kiss-kill").collection("celebs")
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
  const celebids = celebs.map(function(index,val){
    return val._id
  })
  const game = new GameSurvey(celebids)
  try {
    let stuff = await mongoc.db("marry-kiss-kill").collection("gamesurveys").insertOne(game)
    resolve(stuff.insertedId)
  }
  catch(e){
    reject(e)
  }

}


function insertCeleb(celeb,callback){
  if(celeb.constructor.name == "Celeb"){
      mongoc.db("marry-kiss-kill").collection("celebs").insertOne(celeb,function(err){
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




module.exports = {
  getRandomCeleb,
  WARNING_bulkwrite_kitties,
  createNewGameID,
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
