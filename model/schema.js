var generate = require('project-name-generator');
const { ObjectId } = require('mongodb');

const KITTY_BREEDS = [
    "abys", "aege", "abob", "acur", "asho", "awir",
    "amau", "amis", "bali", "bamb", "beng", "birm",
    "bomb", "bslo", "bsho", "bure", "buri", "cspa",
    "ctif", "char", "chau", "chee", "csho", "crex",
    "cymr", "cypr", "drex", "dons", "lihu", "emau",
    "ebur", "esho", "hbro", "hima", "jbob", "java",
    "khao", "kora", "kuri", "lape", "mcoo", "mala",
    "manx", "munc", "nebe", "norw", "ocic", "orie",
    "pers", "pixi", "raga", "ragd", "rblu", "sava",
    "sfol", "srex", "siam", "sibe", "singsstrub", "snow",
    "soma", "sphy", "tonk", "toyg", "tang", "tvan",
    "ycho"
  ]
const randomActiveColors = [
          "purple",
          "blue",
          "border-gradient-topleft",
          "dashboard-tile-bg-gradient-1",
          "dashboard-tile-bg-gradient-end",
          "emoji-foreground",
          "form-label-color",
          "list-kitty-name-gradient-end-color",
          "ultra-violet-1"
]

const randomTexturePrefix = [
          "TexturesCom_Wood_GrateShipdeck_1x1_512_",
          "TexturesCom_Wood_BarkYucca1_0.125x0.125_512_",
          "TexturesCom_Snow_TireMarks4_3x3_1K_",
          "TexturesCom_Snow_Footsteps_2x2_1K_",
          "TexturesCom_Pipe_AluminiumExpanded_0.30x0.30_1K_",
          "TexturesCom_Metal_RustedPlates1_1x1_512_",
          "Concrete_Wall_008_",
          "TexturesCom_Wall_BrickIndustrial5_2x2_1K_",
          "TexturesCom_Brick_CinderblocksPainted2_1K_",
          "Jungle_Floor_001_",
          "Ground_Forest_002_",
          "Concrete_Wall_012_",
          "TexturesCom_SolarCells_1K_",
          "TexturesCom_Wood_SidingOutdoor6_2x2_1K_"
]

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getRandomElementFromArray(arr) {
  const randomIndex = Math.floor(Math.random() * arr.length);
  return arr[randomIndex];
}

class ZipcodeCat {
  generateUniqueRandomNumbers(min, max, count) {
    const uniqueNumbers = new Set();

    while (uniqueNumbers.size < count) {
      const randomNumber = this.getRandomInt(min, max);
      uniqueNumbers.add(randomNumber);
    }

    return Array.from(uniqueNumbers);
  }

  getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

 getToysRequired() {
   let NUM_TOYS = 8
   const min = 0
   let arr = []
   for(let i = 0; i<this.getRandomInt(2,5) ; i++) {
     arr.push(this.getRandomInt(0,NUM_TOYS))
   }
   return arr
 }
 getToysRequired() {
   let NUM_TOYS = 8

   const MIN_TOYS = 2;
   const MAX_TOYS = 5;
   return this.generateUniqueRandomNumbers(0, 8, this.getRandomInt(MIN_TOYS, MAX_TOYS))
 }

  constructor(stuff) {
    const {
      material,
      activeColorName,
      adoption,
      breed
    } = stuff;
    this.requiredToys = this.getToysRequired()
    this.material = material
    this.activeColorName = activeColorName
    if(!!adoption){
      this.adoption = adoption
    }
    this.breed = breed
    this.localid = new ObjectId();
  }
}

class KMKNeighborhood {

  createCats() {

    return cats;
  }

  constructor(stuff) {
    const {
      cats,
      usazipcode
    } = stuff;
    if(!cats) {
      var temp = []
      // Perform the for loop with the random count
      for (let i = 0; i < getRandomInt(5, 10); i++) {
        temp.push(new ZipcodeCat({
          material: getRandomElementFromArray(randomTexturePrefix),
          activeColorName: getRandomElementFromArray(randomActiveColors),
          adoption: undefined,
          breed: getRandomElementFromArray(KITTY_BREEDS)
        }))
      }
      this.cats = temp
    } else {
      cats.forEach((item, i) => {
        if (!(item instanceof ZipcodeCat)) {
          throw "bad init for KMKNeighborhood"
        }
      });
      this.cats = cats
    }

    this.zipcode = usazipcode
  }
}


class Celeb {
  constructor(imgurl){
    this.imgurl = imgurl
    this.name = generate({ words: 3}).dashed;
  }
}


class KMKFutureNotification {
  constructor({vapid,breed,did}){
    this.device_token = vapid
    this.suggested_kitty = breed
    this.timestamp = Date.now()
    this.device_identifier = did
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

/* no longer uses this, a bunch of random cats are decided on the client. im not sure,
 maybe the server should still be doing this, interacting with database stuff */
const BreedMap  = {
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


module.exports = {
  KMKNeighborhood,
  MongoCollectionSurvey,
  Celeb, BreedMap,
  StaleSurveyReference,
  GameSurveyMongo,
  GameSurveySwift,KMKFutureNotification
}
