Q = Game.Q

Q.scene "controls", (stage) ->

  # some math
  marginY = Q.height * 0.15

  marginXinP = 10 # %
  gutterXinP = 8 # %
  columnsNo = 2

  # layout math
  columnInP = (100 - (marginXinP * 2) - (columnsNo - 1) * gutterXinP)/columnsNo  # 24%

  marginX = Q.width * marginXinP * 0.01
  gutterX = Q.width * gutterXinP * 0.01
  columnWidth = Q.width * columnInP * 0.01
  rowHeight = Q.height * 0.3

  # audio
  Q.AudioManager.stopAll()
  Q.AudioManager.clear()

  # add title
  stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY/2
    label: "How to heal’em"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 60

  # add cells, 2x2
  cell1 = stage.insert new Q.UI.Container
    x: marginX + columnWidth/2
    y: Q.height/2 - rowHeight/2

  cell2 = stage.insert new Q.UI.Container
    x: cell1.p.x + gutterX + columnWidth
    y: Q.height/2 - rowHeight/2

  cell3 = stage.insert new Q.UI.Container
    x: marginX + columnWidth/2
    y: Q.height/2 + rowHeight/2

  cell4 = stage.insert new Q.UI.Container
    x: cell1.p.x + gutterX + columnWidth
    y: Q.height/2 + rowHeight/2

  # add 1 step
  numberpad = 50
  step1text = cell1.insert new Q.UI.Text
    x: 0
    y: -100
    label: "Explore the graveyard"
    color: "#9ca2ae"
    family: "Boogaloo"
    size: 30

  cell1.insert new Q.UI.Text
    x: step1text.p.x - step1text.p.w/2 - numberpad
    y: step1text.p.y
    label: "1."
    color: "#f2da38"
    family: "Boogaloo"
    size: 44

  cell1.insert new Q.Sprite
    x: 0
    y: 0
    sheet: "ui_controls_1"

  # add 2 step
  step2text = cell2.insert new Q.UI.Text
    x: 0
    y: step1text.p.y
    label: "Find Healing Gun"
    color: "#9ca2ae"
    family: "Boogaloo"
    size: 30

  cell2.insert new Q.UI.Text
    x: step2text.p.x - step2text.p.w/2 - numberpad 
    y: step2text.p.y
    label: "2."
    color: "#f2da38"
    family: "Boogaloo"
    size: 44

  
  cell2.insert new Q.Sprite
    x: 0
    y: 0
    sheet: "ui_controls_2"

  # add 3 step

  step3text = cell3.insert new Q.UI.Text
    x: 0
    y: step1text.p.y
    label: "Shoot the zombies!"
    color: "#9ca2ae"
    family: "Boogaloo"
    size: 30

  cell3.insert new Q.UI.Text
    x: step3text.p.x - step3text.p.w/2 - numberpad 
    y: step3text.p.y
    label: "3."
    color: "#f2da38"
    family: "Boogaloo"
    size: 44

  cell3.insert new Q.Sprite
    x: 0
    y: 0
    sheet: "ui_controls_3"


  # REPEAT FOR CELL 4 (don't have assets yet)
  
  step4text = cell4.insert new Q.UI.Text
    x: 0
    y: step1text.p.y
    label: "Find the exit"
    color: "#9ca2ae"
    family: "Boogaloo"
    size: 30

  cell4.insert new Q.UI.Text
    x: step4text.p.x - step4text.p.w/2 - numberpad 
    y: step4text.p.y
    label: "4."
    color: "#f2da38"
    family: "Boogaloo"
    size: 44

  cell4.insert new Q.Sprite
    x: 0
    y: 0
    sheet: "ui_controls_1"

  # button
  button = stage.insert new Q.UI.Button
    x: Q.width/2
    y: Q.height - marginY
    w: Q.width/2
    h: 70
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Give me some zombies"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  button.on "click", (e) ->
    Game.stageLevel(1)

