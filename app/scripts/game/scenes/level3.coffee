Q = Game.Q

Q.scene "level3", (stage) ->

  # main map with collision
  Game.map = map = new Q.TileLayer
    type: Game.SPRITE_TILES
    layerIndex: 0
    dataAsset: Game.assets.level3.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 2

  stage.collisionLayer map

  # decorations
  background = new Q.TileLayer
    layerIndex: 1,
    type: Game.SPRITE_NONE
    dataAsset: Game.assets.level3.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 1

  stage.insert background

  # player
  Game.player = player = stage.insert new Q.Player(Q.tilePos(24.5+15, 14+5))

  # camera
  stage.add("viewport")
  Game.setCameraTo(stage, player)

  # enemies
  enemies = [
    ["Zombie", Q.tilePos(8+15, 11+5)]
    ["Zombie", Q.tilePos(9+15, 17+5, {startLeft: true})]

    ["Zombie", Q.tilePos(18+15, 5+5)]
    ["Zombie", Q.tilePos(19+15, 23+5)]

    ["Zombie", Q.tilePos(31+15, 5+5)]
    ["Zombie", Q.tilePos(30+15, 23+5)]

    ["Zombie", Q.tilePos(41+15, 11+5)]
    ["Zombie", Q.tilePos(42+15, 17+5, {startLeft: true})]
  ]

  stage.loadAssets(enemies)

  # items
  randomItems = [
    door: Q.tilePos(46.5+15, 14+5)
    key: Q.tilePos(2.5+15, 14+5)
  ,
    door: Q.tilePos(2.5+15, 14+5)
    key: Q.tilePos(46.5+15, 14+5)
  ]

  random = Math.floor(Math.random() * 2)

  items = [
    ["Key", randomItems[random].key]
    ["Door", randomItems[random].door]
    ["ExitSign", randomItems[random].exitSign]
    ["Gun", Q.tilePos(24.5+15, 2+5, {bullets: 10})]
    ["Heart", Q.tilePos(8+15, 5+5)]
    ["Heart", Q.tilePos(41.5+15, 5+5)]
    ["Heart", Q.tilePos(24.5+15, 26+5)]
  ]

  Game.add_door_button(stage, randomItems[random].door)

  stage.loadAssets(items)

  # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length
