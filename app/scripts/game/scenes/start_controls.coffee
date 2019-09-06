Q = Game.Q

Q.scene "start_controls", (stage) ->

  # add title
  y_pad = Q.height/20

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2

  gray = "#818793"
  yellow = "#f2da38"

  buttonPosX = Q.width/6
  buttonPosY = 0
  marginButtonsY = Q.height/8

  keyboardButton = titleContainer.insert new Q.UI.ToggleButton
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    x: buttonPosX
    y: -buttonPosY
    btn_sheet: "keyboard_controls"
    do_toggle: false

  gazeButton = titleContainer.insert new Q.UI.ToggleButton
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    x: -buttonPosX
    y: -buttonPosY
    btn_sheet: "gaze_touch_etc"
    do_toggle: false
  
  buttonLabelOffset = gazeButton.p.h*0.7 

  titleContainer.insert new Q.UI.Text    
    x: 0
    y: gazeButton.p.y - buttonLabelOffset
    label: "Choose your controls:"
    color: gray
    family: "Boogaloo"
    size: Styles.fontsize5

  gazeText = titleContainer.insert new Q.UI.Text    
    x: gazeButton.p.x
    y: gazeButton.p.y + buttonLabelOffset
    label: "Gaze / mouse / touch"
    family: "Boogaloo"
    size: Styles.fontsize5

  keyboardText = titleContainer.insert new Q.UI.Text    
    x: keyboardButton.p.x
    y: gazeButton.p.y + buttonLabelOffset
    label: "Keyboard"
    family: "Boogaloo"
    size: Styles.fontsize5

  

  # these toggle buttons are exclusive, and don't click off. 
  keyboardButton.on "click", (e) ->
    keyboardButton.pressed = true
    keyboardText.p.color = yellow

    gazeButton.pressed = false
    gazeText.p.color = gray
    

  gazeButton.on "click", (e) ->
    keyboardButton.pressed = false
    keyboardText.p.color = gray
    
    gazeButton.pressed = true
    gazeText.p.color = yellow

  gazeButton.pressed = true
  keyboardText.p.color = gray
  gazeText.p.color = yellow



  
  # cursorLabel = titleContainer.insert new Q.UI.Text
  #   y: buttonPosY
  #   label: "Show cursor?"
  #   color: "#818793"
  #   family: "Boogaloo"
  #   size: Styles.fontsize5

  # label_pad = gazeButton.p.w/4
  # cursorLabel.p.x = gazeButton.p.x - gazeButton.p.w/2 - cursorLabel.p.w/2 - label_pad
  # audioLabel.p.x = keyboardButton.p.x - keyboardButton.p.w/2 - audioLabel.p.w/2 - label_pad

  title = titleContainer.insert new Q.UI.Text
    x: 0
    y: -(Q.height/2 - marginButtonsY)
    label: "Heal'em All"
    color: yellow
    family: "Jolly Lodger"
    size: Styles.fontsize13


  # button
  label = "Continue"
  buttonTextSize = Q.ctx.measureText(label)
  button = titleContainer.insert new Q.UI.Button
    x: 0
    y: Q.height/2 - marginButtonsY
    w: buttonTextSize.width*1.3
    h: 80
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  titleContainer.fit()

  # authors
  authors = stage.insert new Q.UI.Authors()

  stage.insert new Q.UI.CursorWarning


  button.on "click", (e) ->
    # Save the controls
    if gazeButton.pressed
      console.log('Using gaze!')
      Game.settings.useKeyboardInstead.set(false)
      Game.stageScreen("start_settings")

    else if keyboardButton.pressed
      console.log('Using keyboard!')
      Game.settings.useKeyboardInstead.set(true)
      Game.stageLevelSelectScreen()
      Game.turnOffGaze()
