Q = Game.Q

Q.scene "hud_nav_only", (stage) ->

  # Buttons

  marginBottomButtons = Q.height * 0.1

  pauseButton = stage.insert new Q.UI.PauseButton
    x: marginBottomButtons
    y: Q.height - marginBottomButtons    
    isSmall: false

  menuButton = stage.insert new Q.UI.MenuButton
    x: Q.width - marginBottomButtons
    y: Q.height - marginBottomButtons    
    isSmall: false

  menuButton.on "click", (e) ->
    Q.stageScene("restartOptions")

 