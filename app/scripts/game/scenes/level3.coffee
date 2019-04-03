Q = Game.Q

Q.scene "level3", (stage) ->

  level_data = Game.assets.level3.dataAsset
  num_bullets = 6

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 
