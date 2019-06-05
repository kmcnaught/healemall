Q = Game.Q


Q.UI.Container::subplot = (nrows, ncols, rowFrom, colFrom, rowTo, colTo, padding_fraction=0) ->
  cell_w = @p.w/ncols
  cell_h = @p.h/nrows

  rowTo = rowFrom if rowTo is undefined
  colTo = colFrom if colTo is undefined  

  nRowsInSubplot = (1+rowTo-rowFrom)
  nColsInSubplot = (1+colTo-colFrom)

  x = @p.x - @p.w/2 + (colFrom+nColsInSubplot*0.5)*cell_w
  y = @p.y - @p.h/2 + (rowFrom+nRowsInSubplot*0.5)*cell_h

  console.log("container (x, y) = (%d, %d) (w,h) = (%d,%d)", @p.x, @p.y, @p.w, @p.h);
  fill = 1.0-padding_fraction;

  return new Q.UI.Container
          x: x
          y: y
          w: cell_w*nColsInSubplot*fill
          h: cell_h*nRowsInSubplot*fill
 
Q.scene "controls_settings", (stage) ->

  # audio
  Q.AudioManager.stopAll()
  Q.AudioManager.clear()

  # add title
  y_pad = Q.height/20

  pageContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2
    w: Q.width
    h: Q.height

  titleBar = stage.insert pageContainer.subplot(8,1,0,0)

  # console.log("titleBar (x, y) = (%d, %d) (w,h) = (%d,%d)", titleBar.p.x, titleBar.p.y, titleBar.p.w, titleBar.p.h);

  title = titleBar.insert new Q.UI.Text    
    label: "Controls"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: titleBar.p.h*0.8

  buttonBar = stage.insert pageContainer.subplot(8,1,7,0)

  # back button
  label = "Back"
  buttonTextSize = Q.ctx.measureText(label)
  button = buttonBar.insert new Q.UI.Button
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
    Game.stageLevelSelectScreen()

  # preview button
  label = "Preview\ncontrols"  
  previewButton = buttonBar.insert new Q.UI.Button
    x: - Q.width/4    
    h: 50
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 32px Jolly Lodger"
    label: label
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  previewButton.on "click", (e) ->
    console.log('preview coming soon!')



  mainSection = pageContainer.subplot(8,1,1,0,6,0)

    
  cursor_layout =   stage.insert mainSection.subplot(3,2, 0,1, 0,1, 0.1)

  cursorButton = cursor_layout.insert new Q.UI.CursorButton        
    isSmall: false


  cursorLabel = cursor_layout.insert new Q.UI.Text    
    label: "Show cursor?"
    color: "#818793"
    family: "Boogaloo"
    size: 36

  label_pad = cursorButton.p.w/4
  delta =  cursorButton.p.w/2 + cursorLabel.p.w/2 + label_pad
  cursorLabel.p.x = cursorLabel.p.x - delta/2
  cursorButton.p.x = cursorButton.p.x + delta/2



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


  input_layout =   stage.insert mainSection.subplot(3,2, 0,0, 0,0, 0.1)

  scale_layout =   stage.insert mainSection.subplot(3,2, 1,0, 1,0, 0.1)
  dwell_layout =   stage.insert mainSection.subplot(3,2, 2,1, 2,1, 0.1)
  opacity_layout = stage.insert mainSection.subplot(3,2, 2,0, 2,0, 0.1)
  click_layout =   stage.insert mainSection.subplot(3,2, 1,1, 1,1, 0.1)

  Q.CompositeUI.add_adjuster(dwell_layout, 'Dwell time (s)', dwell_getter, dwell_setter, 0.1, 0.1, 3.0)
  Q.CompositeUI.add_adjuster(scale_layout, 'Size of gaze controls', scale_getter, scale_setter, 0.1, 0.2, 2.5)
  Q.CompositeUI.add_adjuster(opacity_layout, 'Opacity of gaze controls', opacity_getter, opacity_setter, 0.05, 0.05, 0.95)

  btn1 = {
    label: "Keyboard"
    sheet: "keyboard_controls"
    init_state: Game.settings.useKeyboardInstead.get()
    doDwell: false
    on_click: () ->
      Game.settings.useKeyboardInstead.set(true)
      scale_layout.p.hidden = true
      opacity_layout.p.hidden = true
      dwell_layout.p.hidden = true
      click_layout.p.hidden = true
      previewButton.p.hidden = true
      cursor_layout.p.hidden = true 
  }
  btn2 = {    
    label: "Gaze/mouse/touch"
    sheet: "gaze_touch_etc"
    init_state: !Game.settings.useKeyboardInstead.get()
    on_click: () ->
      Game.settings.useKeyboardInstead.set(false)
      scale_layout.p.hidden = false
      opacity_layout.p.hidden = false
      dwell_layout.p.hidden = Game.settings.useOwnClickInstead.get()
      click_layout.p.hidden = false
      previewButton.p.hidden = false
      cursor_layout.p.hidden = false
  }
  Q.CompositeUI.add_exclusive_toggle_buttons(input_layout, btn1, btn2, ["Input","method"])

  btn1 = {
    label: "Own click"
    sheet: "own_click"
    init_state: Game.settings.useOwnClickInstead.get()
    doDwell: false
    on_click: () ->
      Game.settings.useOwnClickInstead.set(true)
      dwell_layout.p.hidden = true
  }
  btn2 = {    
    label: "Built in dwell"
    sheet: "dwell_click"
    init_state: !Game.settings.useOwnClickInstead.get()
    on_click: () ->
      Game.settings.useOwnClickInstead.set(false)
      dwell_layout.p.hidden = false
  }
  Q.CompositeUI.add_exclusive_toggle_buttons(click_layout, btn1, btn2, ["Click", "method"])

  # x, y, w, h, label, getter, setter, inc=0.1
  

  # desc = titleContainer.insert new Q.UI.Text
  #     x: 0
  #     y: Q.height*0.15
  #     align: 'center'
  #     label: description
  #     color: "#000000"
  #     family: "Jolly Lodger"
  #     size: 36

  # # panel
  # titleContainer.insert new Q.UI.Container
  #   x: desc.p.x
  #   y: desc.p.y
  #   w: desc.p.w*1.1
  #   h: desc.p.h*1.1
  #   z: desc.p.z - 1
  #   fill: "#e3ecf933",
  #   radius: 8, 
  #   type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # button.on "click", (e) ->
  #   Game.stageLevelSelectScreen()
