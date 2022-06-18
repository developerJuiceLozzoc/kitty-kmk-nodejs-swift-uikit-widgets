var FCM = require('fcm-node');

const { FCM_PUBLIC_KEY,FCM_PRIVATE_KEY } = require("./configureEnv")

var fcm = new FCM(FCM_PRIVATE_KEY);

function postNotificationWithTitleToDevice({banner, vapid, breed ,nid}) {
  const {bannerTitle,bannerBody}  = banner;
  var message = { //this may vary according to the message type (single recipient, multicast, topic, et cetera)
      to: vapid,
      collapse_key: FCM_PUBLIC_KEY,

      notification: {
          title: bannerTitle,
          body: bannerBody,
      },

      data: {  //you can send only notification or only data(or include both)
          ADD_KITTY: "True",
          KITTY_BREED: breed,
          NOTIFICATION_ID: nid
      }
  };
  return new Promise(function(res,rej){
    fcm.send(message, function(err, response){
        if (err) {
            rej(err)
        } else {
          res(response)
        }
    })


  })
}


function postNotificationToDevice( { vapid, breed ,nid}){

  var message = { //this may vary according to the message type (single recipient, multicast, topic, et cetera)
      to: vapid,
      collapse_key: FCM_PUBLIC_KEY,

      notification: {
          title: 'A feline has wandered here',
          body: 'Click to encounter'
      },

      data: {  //you can send only notification or only data(or include both)
          ADD_KITTY: "True",
          KITTY_BREED: breed,
          NOTIFICATION_ID: nid
      }
  };
  return new Promise(function(res,rej){
    fcm.send(message, function(err, response){
        if (err) {
            rej(err)
        } else {
          res(response)
        }
    })


  })
}









module.exports = { postNotificationToDevice,
postNotificationWithTitleToDevice }
