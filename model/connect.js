const config = require("./configureEnv")
const MongoClient = require('mongodb').MongoClient;

const uri = `mongodb+srv://${config.MONGO_USER}:${config.MONGO_PASS}@stadia-gamer-takeout.odpog.gcp.mongodb.net/${config.MONGO_DB_NAME}?retryWrites=true&w=majority`
const client = new MongoClient(uri, { useNewUrlParser: true });

module.exports = client
