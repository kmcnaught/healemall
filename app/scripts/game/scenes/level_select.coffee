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

    enabled = if item <= Game.achievements.availableLevel.get() then true else false

    # tutorial disabled in keyboard-mode
    if Game.settings.useKeyboardInstead.get() and item == 0
      enabled = false

    # put button into container
    container = stage.insert new Q.UI.Container
      x: x
      y: y

    x += columnWidth + gutterX

    # If we've unlocked levels, we'll replace L6 with a link to "more levels"
    if item == 6
      break

    container.insert new Q.UI.LevelButton
      level: item
      x: 0
      y: 0
      w: w
      h: h
      enabled: enabled
      keyActionName: if item == Game.achievements.getNextUncompletedLevel() then "confirm" else null

    # Add label for tutorial
    if item == 0
      container.insert new Q.UI.Text
          x: 0
          y: 0
          label: "Tutorial"
          color: "#404444"
          family: "Jolly Lodger"
          size: Styles.fontsize4

    # add progress stars
    level = item
    if item > 0
      stars = Game.achievements.progress[level].get()

    if stars
      starsX = -60
      starsY = [34, 50, 40]

      for i in [1..stars]
        container.insert new Q.UI.LevelScoreImgSmall
          x: starsX
          y: starsY[i-1]

        starsX += 60

  # end of adding level buttons

  # "More levels!"  
  bonus = container.insert new Q.UI.MoreLevelsButton
      x: 0
      y: 0
      w: w
      h: h

  
  fontsize = 32
  container.insert new Q.UI.Text
      x: 0
      y: -fontsize/2
      label: "Extra"
      color: "#404444"
      family: "Jolly Lodger"
      size: fontsize
  
  container.insert new Q.UI.Text
      x: 0
      y: fontsize/2
      label: "levels"
      color: "#404444"
      family: "Jolly Lodger"
      size: fontsize

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
      size: Styles.fontsize4

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
    size: Styles.fontsize9

  authors = stage.insert new Q.UI.Authors()

  cursorButton = stage.insert new Q.UI.CursorButton   
    y: marginY/2
    
  stage.insert new Q.UI.CursorWarning

  # about button
  aboutButton = stage.insert new Q.UI.Button
    y: marginY/2
    label: "About"
    fill: "#818793"
    radius: 10
    fontColor: "#404444"
    font: "400 32px Jolly Lodger"
    z: 100
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    
  aboutButton.on "click", (e) ->
    Game.stageScreen("about")    

  aboutButton.p.x = marginX + aboutButton.p.w/2  
  cursorButton.p.x = Q.width - marginX - cursorButton.p.w/2

