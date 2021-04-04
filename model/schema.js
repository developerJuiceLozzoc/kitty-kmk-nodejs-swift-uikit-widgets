var generate = require('project-name-generator');

class Celeb {
  constructor(imgurl){
    this.imgurl = imgurl
    this.name = generate({ words: 3}).dashed;
  }
}


class KMKFutureNotification {
  constructor(vapid,breed){
    this.device_token = vapid
    this.suggested_kitty = breed
    this.timestamp = Date.now()
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
let BreedMap
module.exports = {
  MongoCollectionSurvey,
  Celeb, BreedMap,
  StaleSurveyReference,
  GameSurveyMongo,
  GameSurveySwift,KMKFutureNotification
}
BreedMap= {
  abys: 'Abyssinian',aege: 'Aegean',abob: 'American Bobtail',acur: 'American Curl',asho: 'American Shorthair',
  awir: 'American Wirehair',amau: 'Arabian Mau',amis: 'Australian Mist',bali: 'Balinese',bamb: 'Bambino',beng: 'Bengal',birm: 'Birman',bomb: 'Bombay',
  bslo: 'British Longhair',
  bsho: 'British Shorthair',
  bure: 'Burmese',
  buri: 'Burmilla',
  cspa: 'California Spangled',
  ctif: 'Chantilly-Tiffany',
  char: 'Chartreux',
  chau: 'Chausie',
  chee: 'Cheetoh',
  csho: 'Colorpoint Shorthair',
  crex: 'Cornish Rex',
  cymr: 'Cymric',
  cypr: 'Cyprus',
  drex: 'Devon Rex',
  dons: 'Donskoy',
  lihu: 'Dragon Li',
  emau: 'Egyptian Mau',
  ebur: 'European Burmese',
  esho: 'Exotic Shorthair',
  hbro: 'Havana Brown',
  hima: 'Himalayan',
  jbob: 'Japanese Bobtail',
  java: 'Javanese',
  khao: 'Khao Manee',
  kora: 'Korat',
  kuri: 'Kurilian',
  lape: 'LaPerm',
  mcoo: 'Maine Coon',
  mala: 'Malayan',
  manx: 'Manx',
  munc: 'Munchkin',
  nebe: 'Nebelung',
  norw: 'Norwegian Forest Cat',
  ocic: 'Ocicat',
  orie: 'Oriental',
  pers: 'Persian',
  pixi: 'Pixie-bob',
  raga: 'Ragamuffin',
  ragd: 'Ragdoll',
  rblu: 'Russian Blue',
  sava: 'Savannah',
  sfol: 'Scottish Fold',
  srex: 'Selkirk Rex',
  siam: 'Siamese',
  sibe: 'Siberian',
  sing: 'Singapura',
  snow: 'Snowshoe',
  soma: 'Somali',
  sphy: 'Sphynx',
  tonk: 'Tonkinese',
  toyg: 'Toyger',
  tang: 'Turkish Angora',
  tvan: 'Turkish Van',
  ycho: 'York Chocolate'
}
