Q = Game.Q

Q.scene "controls_settings", (stage) ->

  # audio
  Q.AudioManager.stopAll()
  Q.AudioManager.clear()

  # some math

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2

  # vertical divider in center
  titleContainer.insert new Q.UI.Container
    x:0
    y:0
    w: 10
    h: Q.height*0.65
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

  # layout math
  marginY = Q.height * 0.15

  marginXinP = 10 # %
  gutterXinP = 8 # %
  columnsNo = 2

  columnInP = (100 - (marginXinP * 2) - (columnsNo - 1) * gutterXinP)/columnsNo  # 24%

  marginX = Q.width * marginXinP * 0.01
  gutterX = Q.width * gutterXinP * 0.01
  columnWidth = Q.width * columnInP * 0.01
  rowHeight = Q.height * 0.3

  x_pad = 10

  # Add containers for diff settings
  # Each one will contain three cells, e.g. [-] [label] [+]

  container_topleft = titleContainer.insert new Q.UI.Container    
    x: - (marginX/2 + columnWidth/2)
    y: - (rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  container_bottomleft = titleContainer.insert new Q.UI.Container
    x: - (marginX/2 + columnWidth/2)
    y: + (rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  container_topright = titleContainer.insert new Q.UI.Container    
    x: + (marginX/2 + columnWidth/2)
    y: - (rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  container_bottomright = titleContainer.insert new Q.UI.Container
    x: + (marginX/2 + columnWidth/2)
    y: + (rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT



  # button
  label = "Back"
  buttonTextSize = Q.ctx.measureText(label)
  button = stage.insert new Q.UI.Button
    x: Q.width/2
    y: Q.height*0.9
    fill: "#c4da4a"
    w: buttonTextSize*1.2
    radius: 10
    height: 60
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  button.on "click", (e) ->
    Game.stageLevelSelectScreen()


  # button
  label = "Preview controls"
  buttonTextSize = Q.ctx.measureText(label)
  button = stage.insert new Q.UI.Button
    x: Q.width/2
    y: Q.height*0.1
    w: buttonTextSize*1.6
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    height: 60
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  button.on "click", (e) ->
    Game.stageLevelSelectScreen()

