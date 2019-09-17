Q = Game.Q

Q.scene "tutorialSummary", (stage) ->

  # some math
  marginY = Q.height * 0.25
  buttonHeight = 80

  marginXinP = 20 # %
  gutterXinP = 8 # %
  columnsNo = 2

  # layout math
  columnInP = (100 - (marginXinP * 2) - (columnsNo - 1) * gutterXinP)/columnsNo  # 24%

  marginX = Q.width * marginXinP * 0.01
  gutterX = Q.width * gutterXinP * 0.01
  columnWidth = Q.width * columnInP * 0.01

  # audio
  Q.AudioManager.stopAll()

  # add title
  title = stage.insert new Q.UI.Text
    x: Q.width/2
    y: marginY/2
    label: "Well done!"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: Styles.fontsize14

  msgLabel = "You have successfully completed the tutorial\n"
  
  msgLabel += "Are you feeling ready to play for real?"

  # message
  msg = stage.insert new Q.UI.Text
    x: Q.width/2
    y: Q.height/4 + marginY/4
    label: msgLabel
    color: "#c4da4a"
    family: "Boogaloo"
    size: Styles.fontsize5
    align: "center"

  # start main game:
  buttonStart = stage.insert new Q.UI.Button
    x: Q.width/2
    y: Q.height/2
    w: Q.width/4
    h: buttonHeight
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Start game"
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonStart.on "click", (e) ->
    Game.stageScreen("controls")


  # button next
  buttonNext = stage.insert new Q.UI.Button
    y: Q.height - marginY
    w: Q.width/4
    h: buttonHeight
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Try again"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonNext.p.x = Q.width/2 + buttonNext.p.w/2 + 40

  buttonNext.on "click", (e) ->
    Game.stageTutorial()

  # button back
  buttonBack = stage.insert new Q.UI.Button
    y: Q.height - marginY
    w: Q.width/4
    h: buttonHeight
    fill: "#f2da38"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "Main menu"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  buttonBack.p.x = Q.width/2 - buttonBack.p.w/2 - 40

  buttonBack.on "click", (e) ->
    Game.stageLevelSelectScreen()

  # save progress in game
  if Q.state.get("currentLevel") >= Game.achievements.availableLevel.get()
    Game.achievements.availableLevel.set(Q.state.get("currentLevel") + 1)

  # count stars
  score = stage.options.zombies.healed/stage.options.zombies.available
  stars = 0

  if score <= 0.5
    stars = 1
  else if score > 0.5 && score < 0.9
    stars = 2
  else
    stars = 3

  # save only if better than previous
  level = Q.state.get("currentLevel")
  previousStars = Game.achievements.progress[level].get()
  if previousStars < stars
    Game.achievements.progress[level].set(stars)
  
  # track events
  Game.trackEvent("levelSummary:" + Q.state.get("currentLevel"), "score", score)
  Game.trackEvent("levelSummary:" + Q.state.get("currentLevel"), "stars", stars)

  Game.trackEvent("levelSummary:" + Q.state.get("currentLevel"), "Zombie Mode", stage.options.zombieModeFound)
  Game.trackEvent("levelSummary:" + Q.state.get("currentLevel"), "Health collected", stage.options.health.collected + "/" + stage.options.health.available)
  Game.trackEvent("levelSummary:" + Q.state.get("currentLevel"), "Zombies healed", stage.options.zombies.healed + "/" + stage.options.zombies.available)
  Game.trackEvent("levelSummary:" + Q.state.get("currentLevel"), "Bullets wasted", stage.options.bullets.waisted + "/" + stage.options.bullets.available)

