Q = Game.Q

Q.scene "level1", (stage) ->

  # main map with collision
  Game.map = map = new Q.TileLayer
    type: Game.SPRITE_TILES
    layerIndex: 0
    dataAsset: Game.assets.level1.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 2

  stage.collisionLayer map

  # decorations
  background = new Q.TileLayer
    layerIndex: 1,
    type: Game.SPRITE_NONE
    dataAsset: Game.assets.level1.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 1

  stage.insert background

  # player
  Game.player = player = stage.insert new Q.Player(Q.tilePos(3.5+15, 9))

  # camera
  stage.add("viewport")
  Game.setCameraTo(stage, player)

  # enemies
  enemies = [
    ["Zombie", Q.tilePos(14+15, 9)]
  ]

  stage.loadAssets(enemies)

  doorPos = Q.tilePos(27+15, 9)

  # items
  items = [
    ["Key", Q.tilePos(14.5+15, 9)]
    ["Door", doorPos]
    ["Gun", Q.tilePos(14.5+15, 3, {bullets: 3})]
    ["Heart", Q.tilePos(14.5+15, 15)]
  ]
  
  Game.add_door_button(stage, doorPos)

  stage.loadAssets(items)

  # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

