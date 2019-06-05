Q = Game.Q

Q.scene "start_settings", (stage) ->

  # add title
  y_pad = Q.height/20

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2


  buttonPosX = Q.width/12
  buttonPosY = Q.height/8
  marginButtonsY = Q.height/8

  # Sound

  audioButton = titleContainer.insert new Q.UI.AudioButton
    x: buttonPosX
    y: -buttonPosY
    isSmall: false

  cursorButton = titleContainer.insert new Q.UI.CursorButton
    x: buttonPosX
    y: buttonPosY
    isSmall: false

  audioLabel = titleContainer.insert new Q.UI.Text    
    y: -buttonPosY
    label: "Play sounds/music?"
    color: "#818793"
    family: "Boogaloo"
    size: 36

  cursorLabel = titleContainer.insert new Q.UI.Text    
    y: buttonPosY
    label: "Show cursor?"
    color: "#818793"
    family: "Boogaloo"
    size: 36

  label_pad = cursorButton.p.w/4
  cursorLabel.p.x = cursorButton.p.x - cursorButton.p.w/2 - cursorLabel.p.w/2 - label_pad
  audioLabel.p.x = audioButton.p.x - audioButton.p.w/2 - audioLabel.p.w/2 - label_pad

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


  button.on "click", (e) ->
    Game.stageLevelSelectScreen()
