Q = Game.Q

Q.LevelParser =

  load_objects: (dataAsset, ignore_objects) -> 
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
  