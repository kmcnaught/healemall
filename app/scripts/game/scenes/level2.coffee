Q = Game.Q

Q.scene "level2", (stage) ->

  level_data = Game.assets.level2.dataAsset
  num_bullets = 8
  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 
