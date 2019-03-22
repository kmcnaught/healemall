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

  doorPos = Q.tilePos(108-3, 23)

  # items
  items = [
    ["Key", Q.tilePos(108-3,11)]
    ["Door", doorPos]
    ["Gun", Q.tilePos(91-3, 14, {bullets: 20})]
    ["Heart", Q.tilePos(82-3,8)]
  ]
  
  Game.add_door_button(stage, doorPos)

  stage.loadAssets(items)

  # help texts
  yFudge = 1.5
  texts = [
    Q.tilePos(38, 11+yFudge, {label: "Look at the arrows to walk"}),
    Q.tilePos(46, 11+yFudge, {label: "The longer you look, the faster you'll walk"}),
    Q.tilePos(54, 11+yFudge, {label: "Dwell on a jump button to jump sideways"}),
    Q.tilePos(64.5, 8+yFudge, {label: "Try jumping over the gap"}),
    Q.tilePos(73-1.5, 8+yFudge, {label: "Watch out for zombies!"}),
    Q.tilePos(77, 11+yFudge, {label: "Try to get past without being bitten"}),
    Q.tilePos(82-3, 5+yFudge, {label: "Health packs give you an extra life"}),
    Q.tilePos(91-3, 10+yFudge, {label: "Collect the healing gun,"}),
    Q.tilePos(91-3, 10.5+yFudge, {label: "and fire at the zombie"}),
    Q.tilePos(103.5-3, 10+yFudge, {label: "Once you've healed the zombie,"}),
    Q.tilePos(103.5-3, 10.5+yFudge, {label: "find the key and exit"}),
  ]

  for text_props in texts
    stage.insert new Q.UI.HelpText(text_props)    


  # # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length
