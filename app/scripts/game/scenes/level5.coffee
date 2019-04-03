Q = Game.Q

Q.scene "level5", (stage) ->

  level_data = Game.assets.level5.dataAsset
  num_bullets = 3

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 
