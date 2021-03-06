const express = require("express")
const mongoconnect = require("./model/connect")
const bodyparser = require("body-parser")
const PORT = process.env.PORT || 3000;

let router = require("./router")
let app = express()

app.use(bodyparser.json())
app.use("/",router)


mongoconnect.connect(err => {
  if(err) {
    console.log(err);
  }
  else{
    app.listen(PORT,function(err){
      if(err) {console.log(err);}
      else {       console.log("The app is listening on port",PORT);}
    })
  }

});
