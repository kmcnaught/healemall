Q = Game.Q

Q.scene "preview", (stage) ->

  data_asset = Game.assets.preview.dataAsset
  bullets_per_gun = 100

  # main map with collision
  Game.map = Q.LevelParser.load_map(data_asset, Game.SPRITE_TILES, 0)
  stage.collisionLayer Game.map 

  # background decorations
  background = Q.LevelParser.load_map(data_asset, Game.SPRITE_NONE, 1)
  stage.insert background

  objects = Q.LevelParser.parse_objects(data_asset, [])
  Q.LevelParser.load_objects(stage, objects, bullets_per_gun)


