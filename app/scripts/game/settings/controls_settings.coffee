Q = Game.Q
 
Q.scene "controls_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Controls")

  # preview button
  preview_layout = stage.insert buttonBar.subplot(1,2, 0,0)

  label = "Try out\ncontrols"  
  previewButton = preview_layout.insert new Q.UI.Button    
    h: 80    
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 32px Jolly Lodger"
    label: label
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  previewButton.on "click", (e) ->
    Game.stagePreview()


  # cursor    
  cursor_layout =   stage.insert mainSection.subplot(3,2, 0,1, 0.1)

  cursorButton = cursor_layout.insert new Q.UI.CursorButton        
    isSmall: false


  cursorLabel = cursor_layout.insert new Q.UI.Text    
    label: "Show cursor?"
    color: "#818793"
    family: "Boogaloo"
    size: Styles.fontsize5
    align: "center"


  label_pad = cursorButton.p.w/4
  delta =  cursorButton.p.w/2 + cursorLabel.p.w/2 + label_pad
  cursorLabel.p.x -= delta/2
  cursorButton.p.x = cursorButton.p.x + delta/2
  
  Q.CompositeUI.add_cursor_warning(cursor_layout, -delta/2, cursorLabel.p.h)
  
  # Various adjusters

  dwell_getter = () ->
    dTimeMs =  Number.parseFloat(Game.settings.dwellTime.get())
    return dTimeMs/1000

  dwell_setter = (val) ->
    val = val*1000
    Game.setupGaze(val)
    Game.settings.dwellTime.set(val)
  
  scale_getter = () ->
    return Number.parseFloat(Game.settings.uiScale.get())
  
  scale_setter = (val) ->    
    Game.settings.uiScale.set(val)

  opacity_getter = () ->
    return Number.parseFloat(Game.settings.uiOpacity.get())
  
  opacity_setter = (val) ->    
    Game.settings.uiOpacity.set(val)


  input_layout =   stage.insert mainSection.subplot(3,2, 0,0, 0.1)

  scale_layout =   stage.insert mainSection.subplot(3,2, 1,0, 0.1)
  dwell_layout =   stage.insert mainSection.subplot(3,2, 2,1, 0.1)
  opacity_layout = stage.insert mainSection.subplot(3,2, 2,0, 0.1)
  click_layout =   stage.insert mainSection.subplot(3,2, 1,1, 0.1)

  Q.CompositeUI.add_adjuster(dwell_layout, 'Dwell time (s)', dwell_getter, dwell_setter, 0.1, 0.1, 3.0)
  Q.CompositeUI.add_adjuster(scale_layout, 'Size of gaze controls', scale_getter, scale_setter, 0.1, 0.2, 2.5)
  Q.CompositeUI.add_adjuster(opacity_layout, 'Opacity of gaze controls', opacity_getter, opacity_setter, 0.05, 0.05, 0.95)

  btn1 = {    
    label: "Gaze/mouse/touch"
    sheet: "gaze_touch_etc"
    init_state: !Game.settings.useKeyboardInstead.get()
    on_click: (is_initialising) ->
      if not is_initialising
        Game.settings.useKeyboardInstead.set(false)
        Game.setupGaze(Game.settings.dwellTime.get())
      scale_layout.p.hidden = false
      opacity_layout.p.hidden = false
      dwell_layout.p.hidden = Game.settings.useOwnClickInstead.get()
      click_layout.p.hidden = false
      previewButton.p.hidden = false
      cursor_layout.p.hidden = false
  }
  btn2 = {
    label: "Keyboard"
    sheet: "keyboard_controls"
    init_state: Game.settings.useKeyboardInstead.get()
    doDwell: false
    on_click: (is_initialising) ->
      if not is_initialising
        Game.settings.useKeyboardInstead.set(true)
        Game.turnOffGaze()
      scale_layout.p.hidden = true
      opacity_layout.p.hidden = true
      dwell_layout.p.hidden = true
      click_layout.p.hidden = true
      previewButton.p.hidden = true
      cursor_layout.p.hidden = true 
  }
  
  Q.CompositeUI.add_exclusive_toggle_buttons(input_layout, btn1, btn2, "Input\nmethod")

  btn1 = {    
    label: "Built in dwell"
    sheet: "dwell_click"
    init_state: !Game.settings.useOwnClickInstead.get()
    on_click: (is_initialising) ->
      if not is_initialising
        Game.settings.useOwnClickInstead.set(false)
        Game.setupGaze(Game.settings.dwellTime.get())
      dwell_layout.p.hidden = false
  }
  btn2 = {
    label: "Own click"
    sheet: "own_click"
    init_state: Game.settings.useOwnClickInstead.get()
    doDwell: false
    on_click: (is_initialising) ->
      if not is_initialising
        Game.settings.useOwnClickInstead.set(true)
        Game.setupGaze(0)  # this turns off dwelling
      dwell_layout.p.hidden = true
  }
  
  Q.CompositeUI.add_exclusive_toggle_buttons(click_layout, btn1, btn2, "Click\nmethod")

  