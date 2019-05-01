Q = Game.Q

Q.scene "gameOver", (stage) ->

  # some math
  marginY = Q.height * 0.25

  # audio
  Q.AudioManager.stopAll()

  # add title
  title = stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY
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
    y: Q.height/2
    label: "Oh no, you died!\nLooks like the zombies won't be healed today..."
    color: "#c4da4a"
    family: "Boogaloo"
    size: 36
    align: "center"


  # button next
  buttonTryAgain = stage.insert new Q.UI.Button
    y: Q.height - marginY
    w: Q.width/4
    h: 70
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Try again"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonTryAgain.p.x = Q.width/2 + buttonTryAgain.p.w/2 + 40

  buttonTryAgain.on "click", (e) ->
    Game.stageLevel(Q.state.get("currentLevel"))

  # button back
  buttonBack = stage.insert new Q.UI.Button
    y: Q.height - marginY
    w: Q.width/4
    h: 70
    fill: "#f2da38"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Main menu"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonBack.p.x = Q.width/2 - buttonBack.p.w/2 - 40

  buttonBack.on "click", (e) ->
    Game.stageLevelSelectScreen()


