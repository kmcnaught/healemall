Q = Game.Q

Q.Adjuster = 

  add: (stage, x, y, w, h, label, getter, setter, inc=0.1) ->
    # Add 2 buttons that increment/decrement a label in the middle

    cellsize = Math.min(h, w/3)
    fontsize = Math.floor(h/5)
    fontsize_symbols = Math.floor(h/2)

    init_val = getter()  

    # Left hand: decrement
    decButton = stage.insert new Q.UI.Button
      x: x - cellsize
      y: y
      fill: "#c4da4a"
      w: cellsize
      h: cellsize
      radius: 10
      fontColor: "#353b47"
      font: "400 80px Jolly Lodger"
      label: "-"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    # Right hand: increment
    incButton = stage.insert new Q.UI.Button
      x: x + cellsize
      fill: "#c4da4a"
      y: y
      w: cellsize
      h: cellsize
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize_symbols + "px Jolly Lodger"
      label: "+"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


    # Label for setting
    stage.insert new Q.UI.Text
      x: x
      y: y-cellsize/2-fontsize/2
      label: label
      color: "#f2da38"
      family: "Boogaloo"
      size: fontsize

    # Value for setting
    valText = stage.insert new Q.UI.Text
      x: x
      y: y
      label: init_val.toFixed(1)
      color: "#f2da38"
      family: "Boogaloo"
      size: fontsize

    # Callbacks
    decButton.on "click", (e) ->
      setter(getter() - inc)
      valText.p.label = getter().toFixed(1)
      
    incButton.on "click", (e) ->      
      setter(getter() + inc)
      valText.p.label = getter().toFixed(1)
      