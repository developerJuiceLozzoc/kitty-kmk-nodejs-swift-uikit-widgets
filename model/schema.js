var generate = require('project-name-generator');

class Celeb {
  constructor(imgurl){
    this.imgurl = imgurl
    this.name = generate({ words: 3}).dashed;
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

module.exports = {
  Celeb,
  GameSurveyMongo,
  GameSurveySwift,
}
