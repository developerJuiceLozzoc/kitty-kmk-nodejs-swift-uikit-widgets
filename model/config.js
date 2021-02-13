if(process.env.NODE_ENV == production){
  module.exports = {
    "MONGO_USER": process.env.MONGO_USER,
    "MONGO_PASS": process.env.MONGO_PASS,
    "MONGO_DB_NAME": process.env.MONGO_DB_NAME,
  }

}
else{
  module.exports = require("./config.json")
}
