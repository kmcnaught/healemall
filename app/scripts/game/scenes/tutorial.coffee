Q = Game.Q

Q.scene "tutorial", (stage) ->

  # main map with collision
  Game.map = map = new Q.TileLayer
    type: Game.SPRITE_TILES
    layerIndex: 0
    dataAsset: Game.assets.tutorial.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 2

  stage.collisionLayer map

  # decorations
  background = new Q.TileLayer
    layerIndex: 1,
    type: Game.SPRITE_NONE
    dataAsset: Game.assets.tutorial.dataAsset
    sheet: Game.assets.map.sheetName
    tileW: Game.assets.map.tileSize
    tileH: Game.assets.map.tileSize
    z: 1

  stage.insert background

  # player
  Game.player = player = stage.insert new Q.Player(Q.tilePos(38, 13))

  # camera
  stage.add("viewport")
  Game.setCameraTo(stage, player)

  # enemies
  enemies = [
    ["Zombie", Q.tilePos(78, 14, canFallOff: false)]
  ]

  stage.loadAssets(enemies)

  doorPos = Q.tilePos(108, 23)

  # items
  items = [
    ["Key", Q.tilePos(108,11)]
    ["Door", doorPos]
    ["Gun", Q.tilePos(91, 14, {bullets: 20})]
    ["Heart", Q.tilePos(82,8)]
  ]
  
  Game.add_door_button(stage, doorPos)

  stage.loadAssets(items)

  # help texts
  texts = [
    Q.tilePos(38, 11, {label: "Look at the arrows to walk"}),
    Q.tilePos(48, 11, {label: "The longer you look, the faster you'll walk"}),
    Q.tilePos(57, 9.5, {label: "Dwell on a jump button to jump sideways"}),
    Q.tilePos(64.5, 8, {label: "Try jumping over the gap"}),
    Q.tilePos(73, 8, {label: "Watch out for zombies!"}),
    Q.tilePos(77, 11, {label: "Try to get past without being bitten"}),
    Q.tilePos(82, 5, {label: "Health packs give you an extra life"}),
    Q.tilePos(91.5, 11, {label: "Collect the healing gun"}),
    Q.tilePos(97.5, 13, {label: "Fire at the zombie using dwell"}),
    Q.tilePos(103.5, 10, {label: "Once you've healed the zombie,"}),
    Q.tilePos(103.5, 11, {label: "find the key and exit"}),
  ]

  for text_props in texts
    stage.insert new Q.UI.HelpText(text_props)    


  # # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

