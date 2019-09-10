Q = Game.Q

Q.scene "confirm_reset", (stage) ->

  # audio
  Q.AudioManager.stopAll()
  
  font = "400 58px Jolly Lodger"
  Q.ctx.font = font

  reset_text = "Yes, reset everything"
  cancel_text = "Cancel"

  textsize = Q.ctx.measureText(reset_text)
  button_width = textsize.width*1.2

  # some math
  marginY = Q.height * 0.25
  buttonHeight = 80

  marginXinP = 20 # %
  gutterXinP = 8 # %
  columnsNo = 2

  # layout math
  columnInP = (100 - (marginXinP * 2) - (columnsNo - 1) * gutterXinP)/columnsNo  # 24%

  marginX = Q.width * marginXinP * 0.01
  gutterX = Q.width * gutterXinP * 0.01
  columnWidth = Q.width * columnInP * 0.01

  # audio
  Q.AudioManager.stopAll()

  msgLabel = "Are you sure you want to reset all settings to default?"
  
  # message
  msg = stage.insert new Q.UI.Text
    x: Q.width/2
    y: Q.height/4 + marginY/4
    label: msgLabel
    color: "#c4da4a"
    family: "Boogaloo"
    size: Styles.fontsize6
    align: "center"


  # sub-message, with word wrap
  settings_to_ignore = ["cookiesAccepted",]

  msgLabel = "This will affect: " 
  msgOrigLength = msgLabel.length
  msgMaxLength = 80
  msgLines = 1
  for setting of Game.settings    
    if Game.settings[setting].isSaved() and not (setting in settings_to_ignore)
      # Append to list, respecting word wrap
      if msgLabel.length > msgOrigLength
        msgLabel += ", "
      if msgLabel.length > msgMaxLength*msgLines
        msgLabel += "\n"
        msgLines++
      msgLabel += setting 

  # message
  msg = stage.insert new Q.UI.Text
    x: Q.width/2
    y: Q.height/2
    label: msgLabel
    color: "#c4da4a"
    family: "Boogaloo"
    size: Styles.fontsize4
    align: "center"


  buttonCancel = stage.insert new Q.UI.Button
    y: Q.height - marginY
    w: button_width
    h: buttonHeight
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: font
    label: "Cancel"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonCancel.p.x = Q.width/2 + buttonCancel.p.w/2 + 40

  buttonCancel.on "click", (e) ->
    Game.stageScreen("settings_menu")

  buttonReset = stage.insert new Q.UI.Button
    y: Q.height - marginY
    w: button_width
    h: buttonHeight
    fill: "#f2da38"
    radius: 10
    fontColor: "#353b47"
    font: font
    label: "Yes, reset everything"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonReset.p.x = Q.width/2 - buttonReset.p.w/2 - 40

  buttonReset.on "click", (e) ->
    Game.stageLevelSelectScreen()
    for setting of Game.settings
      console.log(setting)


