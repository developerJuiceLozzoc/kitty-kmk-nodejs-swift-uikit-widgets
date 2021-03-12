var generate = require('project-name-generator');

class Celeb {
  constructor(imgurl){
    this.imgurl = imgurl
    this.name = generate({ words: 3}).dashed;
  }
}


class MongoCollectionSurvey {
  constructor({id,imgurls,actions}){
    self._id = id
    self.imgurls = imgurls
    self.actions = actions
  }
}

class GameSurveyMongo {
  constructor(cnstrctr){
    if(Array.isArray(cnstrctr)){
      this.actiona = ""
      this.actionb = ""
      this.actionc = ""
      this.celebs = cnstrctr
    }
    else {
      const  {celebs,actiona,actionb,actionc} = cnstrctr
      this.actiona = actiona
      this.actionb = actionb
      this.actionc = actionc
      this.celebs = celebs
    }
  }
}

class GameSurveySwift {
  constructor(cnstrctr){
      const  {celebs,actiona,actionb,actionc} = cnstrctr
      this.actiona = actiona
      this.actionb = actionb
      this.actionc = actionc
      this.celebs = celebs
    }

}

class StaleSurveyReference {
  constructor(gameid){
    this.reference = gameid
  }
}

module.exports = {
  MongoCollectionSurvey,
  Celeb,
  StaleSurveyReference,
  GameSurveyMongo,
  GameSurveySwift,
}
