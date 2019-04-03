Q = Game.Q

Q.LevelParser =

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
      if obj.name == "Gun"
        # Add bullets
        item =
          [obj.name, Q.tilePos(obj.x, obj.y, {bullets: bullets_per_gun})]   
        all_items.push item
      else if obj.name == "Player"
        # Player and camera together, get added differently
        Game.player = player = stage.insert new Q.Player(Q.tilePos(18.5, 14))
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

    stage.loadAssets(all_items)
