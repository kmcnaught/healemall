Q = Game.Q

Q.CompositeUI = 

  add_adjuster: (layout, label, getter, setter, inc=0.1, min_val, max_val) ->
    # Add 2 buttons that increment/decrement a label in the middle

    h = layout.p.h
    w = layout.p.w    

    num_digits = Math.ceil(-Math.log10(inc*1.05)) # *1.05 to avoid rounding exaggerations

    title_fontsize = Math.floor(h/6)
    label_fontsize = Math.floor(h/4)    

    title = new Q.UI.Text
      label: label
      color: "#f2da38"
      family: "Boogaloo"
      size: title_fontsize

    title.p.y -= (h - title.p.h)/2

    layout.insert title

    x = 0
    y = 0 
    cellsize = Math.min(h, w/3) - title.p.h

    fontsize = Math.floor(h/5)
    fontsize_symbols = Math.floor(h/2)

    init_val = getter()  

    # Left hand: decrement
    decButton = layout.insert new Q.UI.Button
      x: -cellsize
      y: title.p.h/2
      fill: "#c4da4a"
      w: cellsize
      h: cellsize
      radius: 10
      fontColor: "#353b47"
      font: "400 80px Jolly Lodger"
      label: "-"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    # Right hand: increment
    incButton = layout.insert new Q.UI.Button
      x: cellsize
      fill: "#c4da4a"
      y: title.p.h/2
      w: cellsize
      h: cellsize
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize_symbols + "px Jolly Lodger"
      label: "+"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    # Value for setting
    valText = layout.insert new Q.UI.Text
      x: x
      y: title.p.h/2
      label: init_val.toFixed(num_digits)
      color: "#f2da38"
      family: "Boogaloo"
      size: fontsize

    # Callbacks
    decButton.on "click", (e) ->
      new_val = getter() - inc
      if min_val? and new_val < min_val
        new_val = min_val

      setter(new_val)
      valText.p.label = getter().toFixed(num_digits)
      
    incButton.on "click", (e) ->      
      new_val = getter() + inc
      if max_val? and new_val > max_val
        new_val = max_val
      setter(new_val)
      valText.p.label = getter().toFixed(num_digits)
      