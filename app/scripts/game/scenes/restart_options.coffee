Q = Game.Q

Q.scene "restartOptions", (stage) ->

  # # some math
  # marginY = Q.height * 0.25
  buttonHeight = 80

  # marginXinP = 20 # %
  # gutterXinP = 8 # %
  # columnsNo = 2

  # # layout math
  # columnInP = (100 - (marginXinP * 2) - (columnsNo - 1) * gutterXinP)/columnsNo  # 24%

  # marginX = Q.width * marginXinP * 0.01
  # gutterX = Q.width * gutterXinP * 0.01
  # columnWidth = Q.width * columnInP * 0.01

  # audio
  Q.AudioManager.stopAll()


  # button next
  buttonNext = stage.insert new Q.UI.Button
    y: Q.height/2
    w: Q.width/4
    h: buttonHeight
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Restart level"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonNext.p.x = Q.width/2 + buttonNext.p.w/2 + 40

  buttonNext.on "click", (e) ->
    Game.stageLevel(Q.state.get("currentLevel"))

  # button back
  buttonBack = stage.insert new Q.UI.Button
    y: Q.height/2
    w: Q.width/4
    h: buttonHeight
    fill: "#f2da38"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Main menu"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonBack.p.x = Q.width/2 - buttonBack.p.w/2 - 40

  buttonBack.on "click", (e) ->
    Game.stageLevelSelectScreen()
