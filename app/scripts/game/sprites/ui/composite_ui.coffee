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
    backLayout = buttonBar#stage.insert buttonBar.subplot(1,2,0,1)
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
      keyActionName: "escape"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    button.on "click", (e) ->
      if Game.currentScreen == "settings_menu"
        Game.stageLevelSelectScreen()
      else
        Game.stageScreen("settings_menu")

    return [titleBar, mainSection, buttonBar]

  add_cursor_warning: (cursor_layout, x, y) ->     

    cursorWarning = cursor_layout.insert new Q.UI.Text    
      label: "Cursor is currently hidden;\npress 'C' to show cursor"
      color: "#c4da4a"
      family: "Arial"
      size: Styles.fontsize0
      x: x
      y: y
      
    cursorIcon = cursor_layout.insert new Q.UI.WarningIcon
      x: x
      y: y

    # Adjust scale of icon
    rescale = cursorWarning.p.h/cursorIcon.p.h
    cursorIcon.p.scale = rescale
    cursorIcon.size()

    # Shift both to sit alongside    
    delta = cursorWarning.p.w/2 + cursorIcon.p.w*rescale*0.75

    text_shift = 0.25
    cursorWarning.p.x += delta*text_shift
    cursorIcon.p.x -= delta*(1-text_shift)

    # Align bottom of warning with bottom of text for balance (ish)
    y_shift = cursorWarning.p.h*0.1
    cursorIcon.p.y -= y_shift


    update_warning_visibility = () ->
      if Q.state.get("showCursor")
        cursorWarning.p.opacity = 0.0
        cursorIcon.p.opacity = 0.0
      else
        cursorWarning.p.opacity = 1.0
        cursorIcon.p.opacity = 1.0

    Q.state.on "change.showCursor", update_warning_visibility

    update_warning_visibility()


  add_exclusive_toggle_buttons: (layout, btn1_opts, btn2_opts, label) ->
    # callback method takes args (is_checked, is_initialising)
    # When setting up the UI, is_initialising=True. Callbacks from 
    # user actions have is_initialising=False
    
    h = layout.p.h
    w = layout.p.w    

    gray = "#818793"
    darkgray = "#272828"
    yellow = "#f2da38"

    # Background panel to hold elements together visually    
    # (we'll size it later)
    panel = layout.insert new Q.UI.Container      
      fill: "#e3ecf933",      
      radius: 12,
      w:10
      h:10
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


    # Title panel
    title_panel = layout.insert new Q.UI.Container      
      fill: "#e3ecf933",      
      radius: 6,
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

    label_width = 0
    label_height = 0

    main_label = layout.insert new Q.UI.Text
      label: label
      y: label1.p.h/2
      color: darkgray
      family: "Jolly Lodger"
      size: title_fontsize
      align: "center"

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
    
    title_panel.p.w = label_width*1.3
    title_panel.p.h = label_height*1.3
    title_panel.p.x = -title_panel.p.w/2 + 5
    title_panel.p.y = -title_panel.p.h/2 + label1.p.h/2 + 5
    

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

    # If icon missing, replace title with labels in centre
    # (we don't move the existing label since z order is as bit fragile in quintus)
    if not btn1_opts.sheet?
      label1.p.hidden = true
      label1 = layout.insert new Q.UI.Text      
        x: label1.p.x
        y: label1.p.y  + cellsize/2 + label1.p.h/2 
        label: btn1_opts.label
        color: "#f2da38"
        family: "Boogaloo"
        size: title_fontsize
    if not btn2_opts.sheet?
      label2.p.hidden = true
      label2 = layout.insert new Q.UI.Text
        x: label2.p.x  
        y: label2.p.y + cellsize/2 + label2.p.h/2
        label: btn2_opts.label
        color: "#f2da38"
        family: "Boogaloo"
        size: title_fontsize

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

    callback1_click = () ->
      callback1(false)
    callback2_click = () ->
      callback2(false)

    button1.on "click", callback1_click     
    button2.on "click", callback2_click 

    # Initial state: equivalent to clicking one of them
    if btn1_opts.init_state
      callback1(true)
    else
      callback2(true)

  add_checkbox: (layout, label, callback) ->
    h = layout.p.h
    w = layout.p.w    

    chk = layout.insert new Q.UI.Checkbox

    rescale = layout.p.h*0.75/chk.p.h    
    chk.p.scale = rescale

    if callback?      
      chk.on "click", (e) ->
        callback(chk.checked)

    fontsize = Math.floor(h/5)
    label = layout.insert new Q.UI.Text
      label: label
      color: "#f2da38"
      family: "Boogaloo"
      size: fontsize    

    delta = label.p.w/2 + rescale*chk.p.w/2
    
    # if label.p.w + chk.p.w + delta > layout.p.h
      # delta = layout.p.h - (label.p.w + chk.p.w)

    label.p.x += delta/2
    chk.p.x -= delta/2

    return chk



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
  
    updateCallback = (new_val) ->
      setter(new_val)
      valText.p.label = getter().toFixed(num_digits)   

    return updateCallback