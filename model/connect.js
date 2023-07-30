const config = require("./configureEnv")
const MongoClient = require('mongodb').MongoClient;

// mongodb+srv://<user>:<password>@purple-kitty-collector.gqsq7os.mongodb.net/?retryWrites=true&w=majority
//const uri = `mongodb+srv://${config.MONGO_USER}:${config.MONGO_PASS}@stadia-gamer-takeout.odpog.gcp.mongodb.net/${config.MONGO_DB_NAME}?retryWrites=true&w=majority`
const uri = `mongodb+srv://${config.MONGO_USER}:${config.MONGO_PASS}@kitty-cluster.7mtbuok.mongodb.net/${config.MONGO_DB_NAME}?retryWrites=true&w=majority`

// mongodb+srv://maddocks:<password>@kitty-cluster.7mtbuok.mongodb.net/?retryWrites=true&w=majority
// const uri = `mongodb+srv://${config.MONGO_USER}:${config.MONGO_PASS}@purple-kitty-collector.gqsq7os.mongodb.net/${config.MONGO_DB_NAME}?retryWrites=true&w=majority`
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

module.exports = client
