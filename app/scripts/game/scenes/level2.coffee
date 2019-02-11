Q = Game.Q

Q.scene "level2", (stage) ->

  # main map with collision
  Game.map = map = new Q.TileLayer
    type: Game.SPRITE_TILES
    layerIndex: 0
    dataAsset: Game.assets.level2.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 2

  stage.collisionLayer map

  # decorations
  background = new Q.TileLayer
    layerIndex: 1,
    type: Game.SPRITE_NONE
    dataAsset: Game.assets.level2.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 1

  stage.insert background

  # player
  Game.player = player = stage.insert new Q.Player(Q.tilePos(2.5+15, 9+5))

  # camera
  stage.add("viewport")
  Game.setCameraTo(stage, player)

  # enemies
  enemies = [
    ["Zombie", Q.tilePos(9+15, 6+5)]
    ["Zombie", Q.tilePos(8+15, 12+5, {startLeft: true})]
    ["Zombie", Q.tilePos(20+15, 6+5, {startLeft: true})]
    ["Zombie", Q.tilePos(21+15, 12+5)]
  ]

  stage.loadAssets(enemies)

  # items
  randomItems = [
    health: Q.tilePos(14.5+15, 15+5)
    key: Q.tilePos(14.5+15, 3+5)
  ,
    health: Q.tilePos(14.5+15, 3+5)
    key: Q.tilePos(14.5+15, 15+5)
  ]

  random = Math.floor(Math.random() * 2)

  doorPos = Q.tilePos(27+15, 9+5)

  items = [
    ["Key", randomItems[random].key]
    ["Door", doorPos]
    ["Gun", Q.tilePos(14.5+15, 9+5, {bullets: 6})]
    ["Heart", randomItems[random].health]
  ]

  Game.add_door_button(stage, doorPos)

  stage.loadAssets(items)

  # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

