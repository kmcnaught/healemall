Q = Game.Q

Q.scene "start_settings", (stage) ->

  # add title
  y_pad = Q.height/20

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2
    w: Q.width
    h: Q.height



  buttonPosX = Q.width/12
  buttonPosY = Q.height/8
  marginButtonsY = Q.height/8



  padding = 0.1
  audio_layout  = stage.insert titleContainer.subplot(4,2, 1,0, padding)
  cursor_layout  = stage.insert titleContainer.subplot(4,2, 2,0, padding)
  info_layout  = stage.insert titleContainer.subplot_multiple(4,2, 1,1, 2,1, padding)
  

  # Sound
  audioButton = audio_layout.insert new Q.UI.AudioButton
    isSmall: false
    # x: buttonPosX
    # y: -buttonPosY

  cursorButton = cursor_layout.insert new Q.UI.CursorButton
    isSmall: false
    # x: buttonPosX
    # y: buttonPosY

  audioLabel = audio_layout.insert new Q.UI.Text    
    label: "Play sounds/music?"
    color: "#818793"
    family: "Boogaloo"
    size: 36
    # y: -buttonPosY

  cursorLabel = cursor_layout.insert new Q.UI.Text    
    label: "Show cursor?"
    color: "#818793"
    family: "Boogaloo"
    size: 36
    # y: buttonPosY

  delta = audioLabel.p.w/2 + audioButton.p.w/2

  label_pad = cursorButton.p.w/4
  delta += label_pad/2

  cursorLabel.p.x -= delta/2
  audioLabel.p.x -= delta/2

  cursorButton.p.x += delta/2
  audioButton.p.x += delta/2
  
  title = titleContainer.insert new Q.UI.Text
    x: 0
    y: -(Q.height/2 - marginButtonsY)
    label: "Heal'em All"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 90


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


  # Separator bar
  stage.insert new Q.UI.Container
      x: Q.width/2
      y: Q.height/2
      w: 10
      h: Q.height*0.5
      fill: "#81879366",
      radius: 8, 
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # More settings available...


  description = "More options available in the Settings page, including:\n"  
  description += "\n"
  description += "- dwell/click settings\n" 
  description += "- sizing of gaze controls\n" 
  description += "- game difficulty\n"
  description += "- narration\n"

  desc = info_layout.insert new Q.UI.Text
      x: 0
      y: 0
      align: 'center'
      label: description
      color: "#000000"
      family: "Jolly Lodger"
      size: 36

  # panel
  info_layout.insert new Q.UI.Container
    x:0
    y:0
    w: desc.p.w*1.1
    h: desc.p.h*1.1
    z: desc.p.z - 1
    fill: "#e3ecf933",
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  button.on "click", (e) ->
    Game.stageLevelSelectScreen()
