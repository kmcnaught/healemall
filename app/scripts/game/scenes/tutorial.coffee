Q = Game.Q

Q.scene "tutorial", (stage) ->


  data_asset = Game.assets.tutorial.dataAsset
  bullets_per_gun = 20

  # main map with collision
  Game.map = Q.LevelParser.load_map(data_asset, Game.SPRITE_TILES, 0)
  stage.collisionLayer Game.map 

  # background decorations
  background = Q.LevelParser.load_map(data_asset, Game.SPRITE_NONE, 1)
  stage.insert background

  # all other objects, except zombie, which will be special for tutorial
  ignore_objects = ["Zombie",]
  objects = Q.LevelParser.parse_objects(data_asset, ignore_objects)
  Q.LevelParser.load_objects(stage, objects, bullets_per_gun)

  # Add zombie manually
  enemies = [
    ["Zombie", Q.tilePos(78, 14, canFallOff: false)]
  ]
  stage.loadAssets(enemies)

  # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

  # Add help texts
  yFudge = 1.5
  texts = [
    Q.tilePos(38, 11+yFudge, {label: "Look at the arrows to walk"}),
    Q.tilePos(46, 11+yFudge, {label: "The longer you look, the faster you'll walk"}),
    Q.tilePos(54, 11+yFudge, {label: "Dwell on a jump button to jump sideways"}),
    Q.tilePos(64.5, 8+yFudge, {label: "Try jumping over the gap"}),
    Q.tilePos(73-1.5, 8+yFudge, {label: "Watch out for zombies!"}),
    Q.tilePos(77, 11+yFudge, {label: "Try to get past without being bitten"}),
    Q.tilePos(83.5, 8, {label: "<-- Health packs give you an extra life"}),

    Q.tilePos(91-3, 10+yFudge, {label: "Collect the healing gun,"}),
    Q.tilePos(91-3, 10.5+yFudge, {label: "and fire at the zombie"}),

    Q.tilePos(94.5, 14+yFudge, {label: "Once you've healed the zombie,"}),
    Q.tilePos(94.5, 14.5+yFudge, {label: "find the key and exit"}),
  ]

  for text_props in texts
    stage.insert new Q.UI.HelpText(text_props)    


  # # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

