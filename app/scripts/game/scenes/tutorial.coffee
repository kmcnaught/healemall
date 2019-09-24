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

  # overall adjustments
  yFudge = 1.75
  xFudge = 10


  # Add zombie manually
  enemies = [
    ["Zombie", Q.tilePos(xFudge+72, 14, canFallOff: false)]
  ]
  stage.loadAssets(enemies)

  # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

  # Add help texts

  texts = [
    Q.tilePos(xFudge+38, 8+yFudge, {label: "Look at the left and right arrows below to walk"}),
    Q.tilePos(xFudge+46, 11+yFudge, {label: "The longer you look, the faster you'll walk"}),
    Q.tilePos(xFudge+54, 11+yFudge, {label: "Dwell on a jump button to jump sideways"}),
    Q.tilePos(xFudge+64.5, 9+yFudge, {label: "Try jumping over the gap"}),
    Q.tilePos(xFudge+73-1.5, 9+yFudge, {label: "Watch out for zombies!"}),
    Q.tilePos(xFudge+77, 11+yFudge, {label: "Try to get past without being bitten"}),    

    [Q.tilePos(xFudge+83, 10.5+yFudge, {label: "Collect the healing gun,"}),
     Q.tilePos(xFudge+83, 11+yFudge, {label: "and fire at the zombie"}),],

    Q.tilePos(xFudge+88, 9+yFudge, {label: "Health packs give you an extra life -->"}),

    [Q.tilePos(xFudge+92, 13+yFudge, {label: "To complete the level,"}),
     Q.tilePos(xFudge+92, 13.5+yFudge, {label: "find the key and exit"})],
  ]

  typeIsArray = ( value ) ->
    value and
        typeof value is 'object' and
        value instanceof Array and
        typeof value.length is 'number' and
        typeof value.splice is 'function' and
        not ( value.propertyIsEnumerable 'length' )

  clone = (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj

    newInstance  = new obj.constructor()
    newInstance[key] = clone(obj[key]) for key of obj
    return newInstance


  for text_props in texts
    # If we split text over multiple lines (to get nice centering)
    # we need to re-combine for narration.
    if typeIsArray(text_props)
      combined_label = ""
      for component in text_props 
        stage.insert new Q.UI.HelpText(clone(component))    
        combined_label += " " + component.label

      combined_prop = text_props.pop()
      combined_prop.label = combined_label

      helptext = [
        ["InfoPoint", combined_prop]
      ]
    else
      stage.insert new Q.UI.HelpText(text_props)    
    
      helptext = [
        ["InfoPoint", text_props]
      ]

    stage.loadAssets(helptext)    


  # # store level data for level summary
  Game.currentLevelData.health.available = stage.lists.Heart.length
  Game.currentLevelData.zombies.available = stage.lists.Zombie.length

