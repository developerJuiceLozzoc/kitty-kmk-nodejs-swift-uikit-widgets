if(process.env.NODE_ENV == "production"){
  module.exports = {
    "MONGO_USER": process.env.MONGO_USER,
    "MONGO_PASS": process.env.MONGO_PASS,
    "MONGO_DB_NAME": process.env.MONGO_DB_NAME,
    "FCM_PUBLIC_KEY": process.env.FCM_PUBLIC_KEY,
    "FCM_PRIVATE_KEY": process.env.FCM_PRIVATE_KEY,
  }

}
else{
  module.exports = require("./config.json")
}
