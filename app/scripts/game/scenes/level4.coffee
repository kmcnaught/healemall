Q = Game.Q

Q.scene "level4", (stage) ->

  level_data = Game.assets.level4.dataAsset
  num_bullets = 3

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 
