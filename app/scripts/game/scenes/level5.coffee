Q = Game.Q

Q.scene "level5", (stage) ->

  # bg image
  # stage.insert new Q.Background()

  # main map with collision
  Game.map = map = new Q.TileLayer
    type: Game.SPRITE_TILES
    layerIndex: 0
    dataAsset: Game.assets.level5.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 2

  stage.collisionLayer map

  # decorations
  background = new Q.TileLayer
    layerIndex: 1,
    type: Game.SPRITE_NONE
    dataAsset: Game.assets.level5.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 1

  stage.insert background

  # player
  Game.player = player = stage.insert new Q.Player(Q.tilePos(49.5, 21))

  # camera
  stage.add("viewport")
  Game.setCameraTo(stage, player)

  # enemies by columns
  enemies = [
    ["Zombie", Q.tilePos(17+15, 15+5)]
    ["Zombie", Q.tilePos(16+15, 27+5, {startLeft: true})]

    ["Zombie", Q.tilePos(27+15, 20+5)]

    ["Zombie", Q.tilePos(38+15, 9+5)]
    ["Zombie", Q.tilePos(39+15, 15+5, {startLeft: true})]
    ["Zombie", Q.tilePos(39+15, 27+5)]
    ["Zombie", Q.tilePos(39+15, 33+5, {startLeft: true})]

    ["Zombie", Q.tilePos(50+15, 15+5)]
    ["Zombie", Q.tilePos(49+15, 27+5, {startLeft: true})]

    ["Zombie", Q.tilePos(61+15, 9+5)]
    ["Zombie", Q.tilePos(60+15, 15+5, {startLeft: true})]
    ["Zombie", Q.tilePos(60+15, 27+5)]
    ["Zombie", Q.tilePos(60+15, 33+5, {startLeft: true})]

    ["Zombie", Q.tilePos(72+15, 21+5)]

    ["Zombie", Q.tilePos(82+15, 15+5, {startLeft: true})]
    ["Zombie", Q.tilePos(81+15, 27+5)]
  ]

  stage.loadAssets(enemies)


  # items
  doorKeyPositions = [
    door: Q.tilePos(50+15, 3+5)
    sign: Q.tilePos(48+15, 3+5)
    key: Q.tilePos(49.5+15, 39+5)
    heart1: Q.tilePos(5+15, 21+5)
    heart2: Q.tilePos(94+15, 21+5)
  ,
    door: Q.tilePos(49+15, 39+5)
    sign: Q.tilePos(51+15, 39+5)
    key: Q.tilePos(49.5+15, 3+5)
    heart1: Q.tilePos(5+15, 21+5)
    heart2: Q.tilePos(94+15, 21+5)
  ,
    door: Q.tilePos(4+15, 21+5)
    sign: Q.tilePos(6+15, 21+5)
    key: Q.tilePos(94+15, 21+5)
    heart1: Q.tilePos(49.5+15, 39+5)
    heart2: Q.tilePos(49.5+15, 3+5)
  ,
    door: Q.tilePos(95+15, 21+5)
    sign: Q.tilePos(93+15, 21+5)
    key: Q.tilePos(5+15, 21+5)
    heart1: Q.tilePos(49.5+15, 39+5)
    heart2: Q.tilePos(49.5+15, 3+5)
  ]

  bullets = 18
  gunPositions = [
    Q.tilePos(38+15, 15+5, {bullets: bullets})
    Q.tilePos(62+15, 15+5, {bullets: bullets})
    Q.tilePos(37+15, 27+5, {bullets: bullets})
    Q.tilePos(62+15, 27+5, {bullets: bullets})
  ]

  random = Math.floor(Math.random() * 4)

  items = [
    ["Key", doorKeyPositions[random].key]
    ["Door", doorKeyPositions[random].door]
    ["ExitSign", doorKeyPositions[random].sign]
    ["Gun", gunPositions[random]]
    ["Heart", doorKeyPositions[random].heart1]
    ["Heart", doorKeyPositions[random].heart2]

    ["Heart", Q.tilePos(4.5+15, 6+5)]
    ["Heart", Q.tilePos(7.5+15, 39+5)]
    ["Heart", Q.tilePos(94.5+15, 7+5)]
    ["Heart", Q.tilePos(92.5+15, 37+5)]
  ]

  Game.add_door_button(stage, doorKeyPositions[random].door)

  stage.loadAssets(items)

  # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length
