Q = Game.Q

Q.CompositeUI = 


  setup_settings_page: (stage, page_title) ->

    # Audio
    Q.AudioManager.stopAll()
    Q.AudioManager.clear()

    # Layouts
    pageContainer = stage.insert new Q.UI.Container
      x: Q.width/2
      y: Q.height/2
      w: Q.width
      h: Q.height

    titleBar = stage.insert pageContainer.subplot(8,1, 0,0)
    mainSection = pageContainer.subplot_multiple(8,1, 1,0, 6,0)
    buttonBar = stage.insert pageContainer.subplot(8,1, 7,0)    

    # Title
    title = titleBar.insert new Q.UI.Text    
      label: page_title
      color: "#f2da38"
      family: "Jolly Lodger"
      size: titleBar.p.h*0.8

    # back button
    backLayout = stage.insert buttonBar.subplot(1,2,0,1)
    label = "Back"
    buttonTextSize = Q.ctx.measureText(label)
    button = backLayout.insert new Q.UI.Button
      w: buttonTextSize.width*1.3
      h: 80
      fill: "#c4da4a"
      radius: 10
      fontColor: "#353b47"
      font: "400 58px Jolly Lodger"
      label: label
      keyActionName: "confirm"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    button.on "click", (e) ->
      if Game.currentScreen == "settings_menu"
        Game.stageLevelSelectScreen()
      else
        Game.stageScreen("settings_menu")

    return [titleBar, mainSection, buttonBar]

  add_exclusive_toggle_buttons: (layout, btn1_opts, btn2_opts, label_array) ->

    h = layout.p.h
    w = layout.p.w    

    gray = "#818793"
    darkgray = "#363738"
    yellow = "#f2da38"

    # Background panel to hold elements together visually    
    # (we'll size it later)
    panel = layout.insert new Q.UI.Container      
      fill: "#e3ecf933",      
      radius: 12,
      w:10
      h:10
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    title_fontsize = Math.floor(h/6.5)      

    label1 = layout.insert new Q.UI.Text      
      label: btn1_opts.label
      color: "#f2da38"
      family: "Boogaloo"
      size: title_fontsize

    label1.p.y -= (h - label1.p.h)/2

    label2 = layout.insert new Q.UI.Text
      y: label1.p.y
      label: btn2_opts.label
      color: "#f2da38"
      family: "Boogaloo"
      size: title_fontsize

    if label_array?
      create_label = (text) ->
        return layout.insert new Q.UI.Text
          label: text
          y: label1.p.h/2
          color: darkgray
          family: "Jolly Lodger"
          size: title_fontsize

      # Label for control, goes in middle - may be split into 1-3 lines
      n = label_array.length 
      all_labels = []
      for line in label_array
        all_labels.push create_label(line)
      
      if n == 2
        all_labels[0].p.y -= all_labels[0].p.h/2
        all_labels[1].p.y += all_labels[1].p.h/2
      else if n == 3
        all_labels[0].p.y -= all_labels[0].p.h
        all_labels[2].p.y += all_labels[2].p.h


    x = 0
    y = 0 
    cellsize = Math.min(h, w/3) - label1.p.h

    label1.p.x = -cellsize
    label2.p.x = +cellsize

    # Panel sizing    
    panel.p.w = 3*cellsize
    panel.p.h = cellsize
    panel.p.x = -panel.p.w/2 + 5
    panel.p.y = -panel.p.h/2 + label1.p.h/2 + 5
    

    # Left hand: btn1
    button1 = layout.insert new Q.UI.ToggleButton
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      x: -cellsize
      y: label1.p.h/2
      do_toggle: false    
      btn_sheet: btn1_opts.sheet

    if btn1_opts.doDwell?
      button1.doDwell = btn1_opts.doDwell

    # Right hand: btn2
    button2 = layout.insert new Q.UI.ToggleButton
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      x: +cellsize
      y: label1.p.h/2
      do_toggle: false  
      btn_sheet: btn2_opts.sheet

    if btn2_opts.doDwell?
      button2.doDwell = btn2_opts.doDwell

    # Rescale buttons to fit
    rescale = cellsize/Math.max(button1.p.h, button1.p.w)
    console.log('rescaling by %.3f', rescale)
    rescale *= 0.95

    button1.p.scale = rescale
    button2.p.scale = rescale

    # button1.size()
    # button2.size()


    # Callbacks
    callback1 = (e) ->
      button1.pressed = true
      label1.p.color = yellow

      button2.pressed = false
      label2.p.color = gray
    
      btn1_opts.on_click(e)
    
    callback2 = (e) ->
      button1.pressed = false
      label1.p.color = gray

      button2.pressed = true
      label2.p.color = yellow

      btn2_opts.on_click(e)

    button1.on "click", callback1      
    button2.on "click", callback2 

    # Initial state: equivalent to clicking one of them
    if btn1_opts.init_state
      callback1()
    else
      callback2()

  add_adjuster: (layout, label, getter, setter, inc=0.1, min_val, max_val) ->
    # Add 2 buttons that increment/decrement a label in the middle

    h = layout.p.h
    w = layout.p.w    

    num_digits = Math.ceil(-Math.log10(inc*1.05)) # *1.05 to avoid rounding exaggerations

    title_fontsize = Math.floor(h/6.5)

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
      