Q = Game.Q

Q.scene "paused", (stage) ->

  stage.insert new Q.UI.Container
    x: Q.width/2,
    y: Q.height/2,
    w: Q.width,
    h: Q.height
    z: 50
    fill: "rgba(0,0,0,0.5)"

  stage.insert new Q.UI.Text
    x: Q.width/2,
    y: Q.height/2,
    label: "Paused"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: Styles.fontsize14

  # Un-pause button 
  # (We can't reuse a pause button from another stage because we want only this one stage
  # to respond to gaze)

  # Bottom buttons
  marginBottomButtons = Q.height * 0.1

  pauseButton = stage.insert new Q.UI.PauseButton
    x: marginBottomButtons
    y: Q.height - marginBottomButtons    
    isSmall: false
    unpause: true

  
