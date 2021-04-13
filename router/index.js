const express = require("express");
const fs = require("fs");
const mongoc = require("../model/connect");
const {
  getRandomCeleb,
  insertStaleGameReference,
  createNewGameID,
  updateGameResultsWithID,
  updateStaleSurveyAsFulfilled,
  fetchSurveysInRange,
  getCelebImgUrlsFromSurveys,
  findNotificationById,
  createScheduledNotification,
  readAllScheduledNotifications,
  deleteNotification,
  findNotificationByDeviceToken,
} = require("../model");

const { postNotificationToDevice } = require("../model/FCMdao");
const { GameSurveyMongo, BreedMap } = require("../model/schema");
const path = require("path");
module.exports = express();
//* a comment*/

module.exports.get("/stats/adoption", function (req, res) {
  res
    .status(200)
    .sendFile(path.join(__dirname, "../stats/AdoptionRatesByBreed.json"));
});

module.exports.get("/game/new", function (req, res) {
  var response = {
    votes: [0, 1, 2],
  };
  getRandomCeleb()
    .then(function (celebs) {
      response.celebs = celebs;
      return new Promise((resolve, reject) => {
        createNewGameID(celebs, resolve, reject);
      });
    })
    .then(function (gameid) {
      console.log(gameid);
      response._id = gameid;
      return insertStaleGameReference(gameid);
    })
    .then(function () {
      res.status(201).json(response);
    })
    .catch(function (topleevel) {
      console.log("TOPCATCH: ", topleevel);
      res.status(400).send();
    });
});

module.exports.get("/game", function (req, res, next) {
  const { where, offset, limit } = req.query;
  fetchSurveysInRange(parseInt(where), parseInt(offset), parseInt(limit))
    .then(function (surveys) {
      return getCelebImgUrlsFromSurveys(surveys);
    })
    .then(function (aggregated) {
      res.status(200).send(aggregated);
    })
    .catch(function (err) {
      print(err);
      res.status(300).end();
    });
});

module.exports.post("/game/:gameid", function (req, res) {
  let gameid = req.params.gameid;
  const json = req.body;
  if (!gameid) {
    res.status(500).send("Request invalid");
    return;
  }

  let game = new GameSurveyMongo(json);

  updateGameResultsWithID(gameid, game)
    .then(function () {
      return updateStaleSurveyAsFulfilled(gameid);
    })
    .then(function () {
      res.status(200).end();
    })
    .catch(function (err) {
      res.status(300).send("error updateing ", gameid);
    });
});

module.exports.post("/notifications/schedule", function (req, res) {
  const { deviceid, breed } = req.query;
  var status = null;
  findNotificationByDeviceToken(deviceid)
    .then(function (value) {
      console.log(value);
      if (value) {
        status = 400;
        throw "device has already one schedules";
      } else {
        Promise.resolve();
      }
    })
    .catch(function () {
      res.status(400).end();
      throw "err";
    })
    .then(function () {
      return createScheduledNotification({ vapid: deviceid, breed });
    })
    .then(function (success) {
      res.status(201).end();
    })
    .catch(function (err) {
      console.log(err);
      res.status(status || 422).end();
    })
    .finally(function () {});
});

module.exports.post("/notifications/dispatch", function (req, res) {
  readAllScheduledNotifications()
    .then(function (cursor) {
      cursor.forEach(function (val) {
        if (val.device_token && val.suggested_kitty) {
          postNotificationToDevice({
            vapid: val.device_token,
            breed: val.suggested_kitty,
            nid: val._id,
          })
            .then(function () {
              return;
            })
            .catch(function (e) {
              console.log("could not send notification", val);
            });
        }
      });
      res.status(200).end();
    })
    .catch(function (err) {
      console.log(err);
      res.status(300).end();
    });
});

module.exports.delete("/notifications", function (req, res) {
  const { adoption_status, notification_id } = req.query;
  findNotificationById(notification_id)
    .then(function (doc) {
      if (!doc) {
        throw "The document is no exist";
      }
      if (!doc.suggested_kitty) {
        throw "Delete the document";
      }
      return new Promise(function (resolve, reject) {
        fs.readFile("./stats/AdoptionRatesByBreed.json", function (err, data) {
          if (err) {
            reject(err);
          } else {
            resolve({
              json: JSON.parse(data),
              suggested_kitty: doc.suggested_kitty,
              action: adoption_status == "true" ? 1 : -1,
            });
          }
        });
      });
    })
    .then(function ({ json, suggested_kitty, action }) {
      const fullname = BreedMap[suggested_kitty];
      console.log(fullname);
      if (json[fullname]) {
        json[fullname] += action;
      } else {
        json[fullname] = action;
      }
      return new Promise(function (resolve, reject) {
        fs.writeFile(
          "./stats/AdoptionRatesByBreed.json",
          JSON.stringify(json),
          function (error) {
            if (error) {
              reject(error);
            } else {
              resolve();
            }
          }
        );
      });
    })
    .then(function () {})
    .catch(function (e) {
      console.log(e);
    })
    .finally(function () {
      if (notification_id) {
        return deleteNotification(notification_id);
      }
    })
    .then(function () {
      res.status(200).end();
    })
    .catch(function () {
      res.status(300).end();
    });
});
