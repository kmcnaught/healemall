Q = Game.Q

Q.scene "levelSelect", (stage) ->

  # audio
  Q.AudioManager.stopAll()
  Q.AudioManager.clear()

  # layout params
  marginXinP = 20 # %
  marginYinP = 20 # %
  gutterXinP = 8 # %
  gutterYinP = 14 # %
  columnsNo = 4

  # layout math
  columnInP = (100 - (marginXinP * 2) - (columnsNo - 1) * gutterXinP)/columnsNo  # 24%

  marginX = Q.width * marginXinP * 0.01
  gutterX = Q.width * gutterXinP * 0.01
  columnWidth = Q.width * columnInP * 0.01

  marginY = Q.height * marginYinP * 0.01
  gutterY = Q.height * gutterYinP * 0.01
  rowHeight = Q.height * 0.22 # 22%

  # init params
  x = marginX + columnWidth/2
  y = marginY + rowHeight/2
  w = columnWidth
  h = rowHeight

  # prepare special buttons for first column

  # add level buttons
  for item in [0..6]

    if item % columnsNo == 0
      x = marginX + columnWidth/2

      if item > 0
        y += rowHeight + gutterY

    enabled = if item <= Game.availableLevel then true else false

    # put button into container
    container = stage.insert new Q.UI.Container
      x: x
      y: y

    x += columnWidth + gutterX

    container.insert new Q.UI.LevelButton
      level: item
      x: 0
      y: 0
      w: w
      h: h
      enabled: enabled

    # Add label for tutorial
    if item == 0
      container.insert new Q.UI.Text
          x: 0
          y: 0
          label: "Tutorial"
          color: "#404444"
          family: "Jolly Lodger"
          size: 32

    # add progress stars
    level = item
    if item > 0
      stars = localStorage.getItem(Game.storageKeys.levelProgress + ":" + level)

    if stars
      starsX = -60
      starsY = [34, 50, 40]

      for i in [1..stars]
        container.insert new Q.UI.LevelScoreImgSmall
          x: starsX
          y: starsY[i-1]

        starsX += 60


  # end of adding level buttons

  # settings button bottom right
  container = stage.insert new Q.UI.Container
      x: x
      y: y

  settings = container.insert new Q.UI.SettingsButton
      x: 0
      y: 0
      w: w
      h: h
  
  settings_label = container.insert new Q.UI.Text
      x: 0
      y: settings.p.h/6
      label: "Settings"
      color: "#404444"
      family: "Jolly Lodger"
      size: 32

  container.insert new Q.Sprite
    x: 2
    y: settings_label.p.y - settings_label.p.h - 15
    sheet: "settings_button"

  # add title
  stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY/2
    label: "Everything begins here!"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 60

  # authors
  authors = stage.insert new Q.UI.Authors()

  # audio button
  audioButton = stage.insert new Q.UI.AudioButton
    y: marginY/2

  cursorButton = stage.insert new Q.UI.CursorButton   
    y: marginY/2
    

  # about button
  aboutButton = stage.insert new Q.UI.Button
    y: marginY/2
    label: "About"
    fill: "#818793"
    radius: 10
    fontColor: "#404444"
    font: "400 32px Jolly Lodger"
    z: 100
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    
  aboutButton.on "click", (e) ->
    console.log('About!')

  aboutButton.p.x = marginX + aboutButton.p.w/2
  audioButton.p.x = Q.width - marginX - audioButton.p.w/2
  cursorButton.p.x = Q.width - marginX - audioButton.p.w - cursorButton.p.w

