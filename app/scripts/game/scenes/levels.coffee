Q = Game.Q


Q.scene "level1", (stage) ->

  level_data = Game.assets.level1.dataAsset
  num_bullets = 4

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 


Q.scene "level2", (stage) ->

  level_data = Game.assets.level2.dataAsset
  num_bullets = 8
  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 


Q.scene "level3", (stage) ->

  level_data = Game.assets.level3.dataAsset
  num_bullets = 6

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 


Q.scene "level4", (stage) ->

  level_data = Game.assets.level4.dataAsset
  num_bullets = 3

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 


Q.scene "level5", (stage) ->

  level_data = Game.assets.level5.dataAsset
  num_bullets = 15

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 


Q.scene "level6", (stage) ->

  level_data = Game.assets.level6.dataAsset
  num_bullets = 3

  Q.LevelParser.default_load_level(stage, level_data, num_bullets) 
