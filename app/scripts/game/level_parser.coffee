Q = Game.Q

Q.LevelParser =
  # NB most of these methods modifies the global Game object

  default_load_level: (stage, data_asset, bullets_per_gun) ->
    # If no customisation is required, this encapsulates all level loading      

    # main map with collision
    Game.map = @load_map(data_asset, Game.SPRITE_TILES, 0)
    stage.collisionLayer Game.map 

    # background decorations
    background = @load_map(data_asset, Game.SPRITE_NONE, 1)
    stage.insert background

    # all other objects (player, zombies, gun, health, door etc)
    objects = @parse_objects(data_asset, [])
    @load_objects(stage, objects, bullets_per_gun)

    # store level data for level summary
    Game.currentLevelData.health.available = stage.lists.Heart.length
    Game.currentLevelData.zombies.available = stage.lists.Zombie.length

  load_map: (data_asset, sprite_type, layer_index) ->
    return new Q.TileLayer
      type: sprite_type
      layerIndex: layer_index
      dataAsset: data_asset
      sheet: Game.assets.map.sheetName
      tileW: Game.assets.map.tileSize
      tileH: Game.assets.map.tileSize
      z: 2

  parse_objects: (dataAsset, ignore_objects) -> 
    fileParts = dataAsset.split(".")
    fileExt = fileParts[fileParts.length-1].toLowerCase()

    if (fileExt == "tmx" || fileExt == "xml") 
      parser = new DOMParser()
      doc = parser.parseFromString(Q.asset(dataAsset), "application/xml")
      objects = doc.getElementsByTagName("object")

      data = []
      for obj in objects        
        name_lowercase = obj.getAttribute('name')
        # capitalise first letter
        name = name_lowercase.charAt(0).toUpperCase() + name_lowercase.slice(1) 
        # legacy inconsistencies
        if name == "Health"
          name = "Heart"
        if name not in ignore_objects
          item =
            name: name
            x: obj.getAttribute('x')/Game.assets.map.tileSize
            y: obj.getAttribute('y')/Game.assets.map.tileSize
            w: obj.getAttribute('width')/Game.assets.map.tileSize
            h: obj.getAttribute('height')/Game.assets.map.tileSize

          data.push item

      return data
    
    else 
      throw "file type not supported"
  
  load_objects: (stage, objects, bullets_per_gun) ->
    
    all_items = []

    for obj in objects
      if obj.name in ["Key", "Gun", "Zombie", "Door", "Player", "Heart", "Health"]
        if obj.name == "Gun"
          # Add bullets
          item =
            [obj.name, Q.tilePos(obj.x, obj.y, {bullets: bullets_per_gun})]   
          all_items.push item
        else if obj.name == "Zombie"
          # Face random direction
          randomBool = Math.floor(Math.random() * 2) 
          console.log(randomBool)
          item =
            [obj.name, Q.tilePos(obj.x, obj.y, {startLeft: randomBool, canFallOff: false})]   
          all_items.push item
        else if obj.name == "Player"
          # Player and camera together, get added differently
          Game.player = player = stage.insert new Q.Player(Q.tilePos(obj.x, obj.y))
          stage.add("viewport")
          Game.setCameraTo(stage, player)
        else if obj.name == "Door"
          all_items.push [obj.name, Q.tilePos(obj.x, obj.y)]   
          # Add door button for gaze
          Game.add_door_button(stage, Q.tilePos(obj.x, obj.y))
        else
          item =
            [obj.name, Q.tilePos(obj.x, obj.y)]   
          all_items.push item
      else
        console.log("Cannot create object: #{obj.name}")

    stage.loadAssets(all_items)
