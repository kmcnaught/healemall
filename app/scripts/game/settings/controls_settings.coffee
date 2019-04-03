Q = Game.Q

Q.scene "controls_settings", (stage) ->

  # some math
  marginY = Q.height * 0.15

  marginXinP = 10 # %
  gutterXinP = 8 # %
  columnsNo = 2

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2

  # vertical divider in center
  titleContainer.insert new Q.UI.Container
    x:0
    y:0
    w: 10
    h: Q.height*0.75
    fill: "#2a2f38",
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # headings
  titleContainer.insert new Q.UI.Text
    x:-Q.width/4
    y:-Q.height*.4
    family: "Jolly Lodger"
    size: 40
    label: "SELECTION METHOD"
    fill: "#353b47",
    radius: 10, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
  
  titleContainer.insert new Q.UI.Text
    x:Q.width/4
    y:-Q.height*.4
    label: "APPEARANCE"
    family: "Jolly Lodger"
    size: 40
    fill: "#353b47",
    radius: 10, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # button
  label = "Back"
  buttonTextSize = Q.ctx.measureText(label)
  button = titleContainer.insert new Q.UI.Button
    x: 0
    y: 350
    w: 150
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

