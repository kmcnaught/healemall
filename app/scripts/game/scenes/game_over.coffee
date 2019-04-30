Q = Game.Q

Q.scene "gameOver", (stage) ->

  # some math
  marginY = Q.height * 0.25

  # audio
  Q.AudioManager.stopAll()

  # add title
  title = stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY/2
    label: "Game Over"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 100

  # Split up rest of space equally
  offset_y = title.p.y/2 + title.p.h/2
  remaining_height = Q.height - offset_y
  y_per_element = remaining_height/4

  # message
  msg = stage.insert new Q.UI.Text
    x: Q.width/2
    y: offset_y + 1*y_per_element
    label: "Oh no, you died!"
    color: "#c4da4a"
    family: "Boogaloo"
    size: 36
    align: "center"

  mainMenuLabel = "Back to main menu"
  tryAgainLabel = "Try again"
  buttonWidth = 400

  buttonTryAgain = stage.insert new Q.UI.Button
    x: Q.width/2
    y: offset_y + 2*y_per_element
    w: buttonWidth
    h: 90
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: tryAgainLabel
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonMainMenu = stage.insert new Q.UI.Button
    x: Q.width/2
    y: offset_y + 3*y_per_element
    w: buttonWidth
    h: 90
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: mainMenuLabel
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  buttonMainMenu.on "click", (e) ->
    Game.stageLevelSelectScreen()

  buttonTryAgain.on "click", (e) ->
    Game.stageLevel(Q.state.get("currentLevel"))
