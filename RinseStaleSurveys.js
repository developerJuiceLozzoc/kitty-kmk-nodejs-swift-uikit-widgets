const mongoconnect = require("./model/connect")
const { bulk_deleteExpiredGames,
  bulk_rinseStaleCollection,
  mapStaleGames } = require("./model")

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
    })
    .catch(function(err){
      console.log("woops",err);
    })
    .finally(function(err){
      client.close()
    })


  }

});
