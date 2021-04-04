const mongoconnect = require("./model/connect")
const { bulk_deleteExpiredGames,
  bulk_rinseStaleCollection,
  mapStaleGames,readAllScheduledNotifications } = require("./model")
const  {postNotificationToDevice} = require("./model/FCMdao")

mongoconnect.connect((err,client) => {
  if(err) {
    console.log(err);
  }
  else{
    mapStaleGames()
    .then(function(ids){
      return new Promise(function(resolve,reject){
        bulk_deleteExpiredGames(ids.references)
        .then(function(){
          resolve(ids.ids)
        })
        .catch(function(err){
          reject(err)
        })
      })
    })
    .then(function(staleids){
      return bulk_rinseStaleCollection(staleids)
    })
    .then(function(numRecords){
      console.log(`Rinse completed successfully and deleted ${numRecords} records` );
      return Promise.resolve()
    })
    .then(function(){
      return readAllScheduledNotifications()
    })
    .then(function(cursor){
      cursor.forEach(function(val){
        if(val.device_token && val.suggested_kitty){
          postNotificationToDevice({
            vapid: val.device_token,
             breed: val.suggested_kitty})
          .then(function(){return})
          .catch(function(e){
            console.log("could not send notification",val);
          })
        }
      })
      return Promise.resolve()
    })
    .catch(function(err){
      console.log("woops",err);
    })
    .finally(function(err){
      client.close()
    })


  }

});

// also i will have to send any current notifications pending by apps
