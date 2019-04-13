Q = Game.Q

Q.scene "levelSelectMore", (stage) ->

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
  bonusUnlocked = localStorage.getItem(Game.storageKeys.unlockedBonus)

  for item in [0..6]

    if item % columnsNo == 0
      x = marginX + columnWidth/2

      if item > 0
        y += rowHeight + gutterY

    # put button into container
    container = stage.insert new Q.UI.Container
      x: x
      y: y

    x += columnWidth + gutterX

    if item == 0 # previous button  
      enabled = Game.moreLevelsPage > 0
      container.insert new Q.UI.MoreLevelsButton
        x: 0
        y: 0
        w: w
        h: h
        page: Game.moreLevelsPage-1
        enabled: enabled  

        fontsize = 32
      container.insert new Q.UI.Text
          x: 0
          y: -fontsize/2
          label: "Previous"
          color: "#404444"
          family: "Jolly Lodger"
          size: fontsize
      
      container.insert new Q.UI.Text
          x: 0
          y: fontsize/2
          label: "page"
          color: "#404444"
          family: "Jolly Lodger"
          size: fontsize       

    else if item == 3 # next button
      container.insert new Q.UI.MoreLevelsButton
        x: 0
        y: 0
        w: w
        h: h
        page: Game.moreLevelsPage+1
        # enabled: Game.moreLevelsPage > 0        

        fontsize = 32
      container.insert new Q.UI.Text
          x: 0
          y: -fontsize/2
          label: "Next"
          color: "#404444"
          family: "Jolly Lodger"
          size: fontsize
      
      container.insert new Q.UI.Text
          x: 0
          y: fontsize/2
          label: "page"
          color: "#404444"
          family: "Jolly Lodger"
          size: fontsize       
    
    else
      # work out level numbr
      if item == 4
        level = 6 # special case for last 'main' level
      else
        level = item+6+Game.moreLevelsPage*4
        if item > 3
          level = level-2
      
      button = new Q.UI.LevelButton
        level: level
        x: 0
        y: 0
        w: w
        h: h
        enabled: true
      
      container.insert button
        
      # add label if level has name
      # ugh, there's a bit of confusion here with off-by-one indexing
      level_name = Game.levels_array[level].name
      
      if level_name
        name_width = Q.ctx.measureText(level_name).width
        fontsize = 28

        # background panel
        container.insert new Q.UI.Container
          x: 0
          y: button.p.h*.5-fontsize*0.05
          w: name_width*1.1
          h: fontsize*1.1
          radius: 2
          fill: "#81879366",
          type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

        # foreground text
        container.insert new Q.UI.Text
          x: 0
          y: button.p.h*.5
          label: level_name
          color: "#000000"
          family: "Jolly Lodger"
          size: fontsize   
      
      # add progress stars#          
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

  
  # Back button bottom right
  container = stage.insert new Q.UI.Container
      x: x
      y: y

  # TODO: make this a generic 'tombstone button' and
  # let onclick change for settings/back/etc.
  back = container.insert new Q.UI.SettingsButton
      x: 0
      y: 0
      w: w
      h: h

  back.on "click", (e) ->
    Game.stageLevelSelectScreen()
  
  back_label = container.insert new Q.UI.Text
      x: 0
      y: 0
      label: "Back"
      color: "#404444"
      family: "Jolly Lodger"
      size: 32

  # separator bars
  x_sep = marginX + columnWidth + gutterX/2
  for x in [x_sep, Q.width - x_sep ]
    stage.insert new Q.UI.Container
      x: x
      y: Q.height/2
      w: 10
      h: Q.height*0.65
      fill: "#81879366",
      radius: 8, 
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # add title
  stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY/2
    label: "Bonus levels!"
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

