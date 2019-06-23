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
  

  font = "400 48px Jolly Lodger"
  Q.ctx.font = font

  buttonWidth = 1.1*Q.ctx.measureText("Back to all levels").width
  buttonWidth = Math.max(buttonWidth, Q.width/5)
  buttonHeight = Math.min(Q.height/3, Q.width/5)
  

  # button next
  buttonNext = stage.insert new Q.UI.Button
    y: Q.height/2
    w: buttonWidth
    h: buttonHeight
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: font
    label: "Restart level"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  buttonNext.on "click", (e) ->
    Game.stageLevel(Q.state.get("currentLevel"))

  # button back
  buttonBack = stage.insert new Q.UI.Button
    y: Q.height/2
    w: buttonWidth
    h: buttonHeight
    fill: "#f2da38"
    radius: 10
    fontColor: "#353b47"
    font: font 
    label: "Back to all levels"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  buttonBack.on "click", (e) ->
    Game.stageLevelSelectScreen()

  # resume
  buttonResume = stage.insert new Q.UI.Button
    y: Q.height/2
    w: buttonWidth
    h: buttonHeight
    fill: "#f2da38"
    radius: 10
    fontColor: "#353b47"
    font: font
    label: "Resume game"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonResume.on "click", (e) ->
    console.log('not yet implemented!')


  # layout
  buttonNext.p.x = Q.width*0.2
  buttonBack.p.x = Q.width*(1.0-0.2)
  buttonResume.p.x = Q.width/2
