Q = Game.Q

Q.scene "achievement_unlocked", (stage) ->

  message = stage.options.message

  # some math
  marginY = Q.height * 0.25

  # audio
  Q.AudioManager.stopAll()

  # add title
  stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY/2
    label: "Achievement Unlocked!"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 100

  # message
  stage.insert new Q.UI.Text
    x: Q.width/2
    y: Q.height/2
    label: message
    color: "#c4da4a"
    family: "Boogaloo"
    size: 36
    align: "center"

  # button
  button = stage.insert new Q.UI.Button
    x: Q.width/2
    y: Q.height - marginY/2
    w: Q.width/3
    h: 70
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Back to all levels"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # Narrate score
  if Game.settings.narrationEnabled.get()      
      responsiveVoice.speak(message);

  button.on "click", (e) ->
    Game.stageLevelSelectScreen()