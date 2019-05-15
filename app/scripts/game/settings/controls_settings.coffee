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
    x: -(marginX/2 + columnWidth/2)
    y: -(rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  container_bottomleft = titleContainer.insert new Q.UI.Container
    x: -(marginX/2 + columnWidth/2)
    y: +(rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  container_topright = titleContainer.insert new Q.UI.Container    
    x: +(marginX/2 + columnWidth/2)
    y: -(rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  container_bottomright = titleContainer.insert new Q.UI.Container
    x: +(marginX/2 + columnWidth/2)
    y: +(rowHeight/2 + marginY/4)
    w: columnWidth
    h: rowHeight
    fill: "#2a2f38",
    opacity: 0.8
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # more math
  cellsize = container_topleft.p.w/4
  pad = 10

  # Click method
  container_topleft.insert new Q.UI.PolygonButton
    fill: "#c4da4a"
    x: - (cellsize + pad)
    w: cellsize
    h: cellsize
    radius: 10
    height: 60
    fontColor: "#353b47"
    font: "400 40px Jolly Lodger"
    label: "Dwell Click"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    points: [
      [0,90],
      [-60,-50],
      [85,0],
      [-70,60],
      [30,-90],
    ]
  

  stage.insert new Q.UI.Button
    x: + (cellsize + pad)
    fill: "#c4da4a"
    w: cellsize
    h: cellsize
    radius: 10
    height: 60
    fontColor: "#353b47"
    font: "400 40px Jolly Lodger"
    label: "Own Click"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    z: 100

  container_topleft.on "click", (e) ->
    console.log('wibble')

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

  Q.Adjuster.add(stage, Q.width/2, Q.height/2, 400, 200,'Dwell time (s)', 'dwellTime')

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




  # # add cells, 2x2
  # x_pad = -50 # to account for images on right of centralised text

  # cell1 = stage.insert new Q.UI.Container
  #   x: marginX + columnWidth/2 + x_pad
  #   y: Q.height/2 - rowHeight/2 + title.p.h
  #   w: columnWidth
  #   h: rowHeight
    

  # cell2 = stage.insert new Q.UI.Container
  #   x: cell1.p.x + gutterX + columnWidth + x_pad 
  #   y: Q.height/2 - rowHeight/4 + title.p.h
  #   w: columnWidth
  #   h: rowHeight
    
  # cell3 = stage.insert new Q.UI.Container
  #   x: marginX + columnWidth/2 + x_pad 
  #   y: Q.height/2 + rowHeight/4 + title.p.h
  #   w: columnWidth
  #   h: rowHeight
    
  # cell4 = stage.insert new Q.UI.Container
  #   x: cell1.p.x + gutterX + columnWidth + x_pad 
  #   y: Q.height/2 + rowHeight/2 + title.p.h
  #   w: columnWidth
  #   h: rowHeight
    
  # # add 1 step
  # numberpad = 40
  # row2offset = 30

  # step1text = cell1.insert new Q.UI.Text
  #   x: 0
  #   y: -100
  #   label: "Explore the graveyard"
  #   color: "#9ca2ae"
  #   family: "Boogaloo"
  #   size: 30

  # cell1.insert new Q.UI.Text
  #   x: step1text.p.x - step1text.p.w/2 - numberpad
  #   y: step1text.p.y
  #   label: "1."
  #   color: "#f2da38"
  #   family: "Boogaloo"
  #   size: 44

  # cell1.insert new Q.Sprite
  #   x: step1text.p.x + step1text.p.w/2 + 160 
  #   y: step1text.p.y  - 15
  #   sheet: "controls_eyegaze"

  # # add 2 step
  # step2text = cell2.insert new Q.UI.Text
  #   x: 0
  #   y: step1text.p.y
  #   label: "Find Healing Gun"
  #   color: "#9ca2ae"
  #   family: "Boogaloo"
  #   size: 30

  # cell2.insert new Q.UI.Text
  #   x: step2text.p.x - step2text.p.w/2 - numberpad 
  #   y: step2text.p.y
  #   label: "2."
  #   color: "#f2da38"
  #   family: "Boogaloo"
  #   size: 44
  
  # sprite = cell2.insert new Q.Sprite
  #   x: step2text.p.x + step2text.p.w/2 + 120 
  #   y: step2text.p.y
  #   sheet: "controls_gun"

  # # add 3 step

  # step3text = cell3.insert new Q.UI.Text
  #   x: step1text.p.x
  #   y: step1text.p.y
  #   label: "Shoot the zombies!"
  #   color: "#9ca2ae"
  #   family: "Boogaloo"
  #   size: 30

  # cell3.insert new Q.UI.Text
  #   x: step3text.p.x - step3text.p.w/2 - numberpad 
  #   y: step3text.p.y
  #   label: "3."
  #   color: "#f2da38"
  #   family: "Boogaloo"
  #   size: 44

  # cell3.insert new Q.Sprite
  #   x: step3text.p.x + step3text.p.w/2 + 100 
  #   y: step3text.p.y
  #   sheet: "controls_zombie"
  
  # step4text = cell4.insert new Q.UI.Text
  #   x: step2text.p.x
  #   y: step1text.p.y
  #   label: "Find the exit"
  #   color: "#9ca2ae"
  #   family: "Boogaloo"
  #   size: 30

  # cell4.insert new Q.UI.Text
  #   x: step4text.p.x - step4text.p.w/2 - numberpad 
  #   y: step4text.p.y
  #   label: "4."
  #   color: "#f2da38"
  #   family: "Boogaloo"
  #   size: 44

  # cell4.insert new Q.Sprite
  #   x: step4text.p.x + step4text.p.w/2 + 120 
  #   y: step4text.p.y
  #   sheet: "controls_door"

  # # button
  # button = stage.insert new Q.UI.Button
  #   x: Q.width/2
  #   y: Q.height - marginY
  #   w: Q.width/2
  #   h: 70
  #   fill: "#c4da4a"
  #   radius: 10
  #   fontColor: "#353b47"
  #   font: "400 58px Jolly Lodger"
  #   label: "Give me some zombies"
  #   keyActionName: "confirm"
  #   type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # button.on "click", (e) ->
  #   Game.stageLevel(1)

