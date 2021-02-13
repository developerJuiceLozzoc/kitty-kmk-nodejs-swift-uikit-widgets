
class Celeb {
  constructor(name,imgurl){
    this.name = name
    this.img = imgurl
  }
}

class GameSurvey {
  constructor(celebs){
    this.results = {}
    this.celebs = celebs
  }
}


module.exports = {
  Celeb,
  GameSurvey,
}
