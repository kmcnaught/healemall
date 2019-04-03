Q = Game.Q

Q.scene "level1", (stage) ->

  level_data = Game.assets.level1.dataAsset
  num_bullets = 4

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 
