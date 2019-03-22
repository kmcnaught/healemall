Q = Game.Q

Q.scene "hud", (stage) ->

  # stage.insert new Q.UI.RadialGradient()
  stage.insert new Q.UI.LinearGradient()

  # doctor's comments
  Game.playerAvatar = playerAvatar = stage.insert new Q.UI.PlayerAvatar
    z: 10

  infoContainer = stage.insert new Q.UI.Container
    y: 40
    z: 10
    fill: "#fff"

  Game.infoLabel = infoContainer.insert new Q.UI.InfoLabel
    container: infoContainer
    offsetLeft: playerAvatar.p.w

  # enemies counter
  enemiesContainer = stage.insert new Q.UI.Container
    y: 40
    z: 10
    fill: "#232322"

  enemiesContainer.insert new Q.UI.EnemiesCounter()
  enemiesContainer.fit(0, 8)
  enemiesContainer.p.x = Q.width - enemiesContainer.p.w/2 - 60

  stage.insert new Q.UI.EnemiesAvatar
    z: 12

  # bullets counter
  bulletsContainer = stage.insert new Q.UI.Container
    y: 40
    z: 10
    fill: "#232322"

  bulletsImg = bulletsContainer.insert new Q.UI.BulletsImg()
  bulletsContainer.insert new Q.UI.BulletsCounter
    img: bulletsImg.p

  bulletsContainer.fit(0, 8)
  bulletsContainer.p.x = enemiesContainer.p.x - enemiesContainer.p.w/2 - bulletsContainer.p.w/2 - 20 + 30

  # health counter
  healthContainer = stage.insert new Q.UI.Container
    y: 40
    z: 10
    fill: "#232322"

  Game.healthImg = healthImg = healthContainer.insert new Q.UI.HealthImg()
  healthContainer.insert new Q.UI.HealthCounter
    img: healthImg.p

  healthContainer.fit(0, 8)
  healthContainer.p.x = bulletsContainer.p.x - bulletsContainer.p.w/2 - healthContainer.p.w/2 - 20

  # inventory key
  keyContainer = stage.insert new Q.UI.Container
    y: 40
    z: 10
    fill: "#232322"

  keyImg = keyContainer.insert new Q.UI.InventoryKey()

  keyContainer.fit(5, 8)
  keyContainer.p.x = healthContainer.p.x - healthContainer.p.w/2 - keyContainer.p.w/2 - 34

  # buttons
  marginBottomButtons = Q.height * 0.1

  pauseButton = stage.insert new Q.UI.PauseButton
    x: Q.width/2
    y: Q.height - marginBottomButtons    
    isSmall: false

  menuButton = stage.insert new Q.UI.MenuButton
    x: Q.width - marginBottomButtons
    y: Q.height - marginBottomButtons    
    isSmall: false

  audioButton = stage.insert new Q.UI.AudioButton
    x: marginBottomButtons
    y: Q.height - marginBottomButtons    
    isSmall: false

  # gaze controls  
  n = 5
  labels = ['jump', '<', 'fire', '>', 'jump']
  dwell_actions = ['jumpleft', '', 'fire', '', 'jumpright']
  hover_actions = ['', 'left', '', 'right', '']  

  width = Q.width/10
  margin = width/15  

  w = width
  h = width

  x = (Q.width - n*(width+2*margin))/2 + margin + width/2
  y = Q.height/2 + width/2 + 2*margin 


  onClick = (action) => (e) => 
    if action
      console.log('click %s', action)        
      Q.inputs[action]=1
      Q.input.trigger(action);

  onHover = (action) => (e) => 
    if action
      console.log('hover %s', action)        
      Q.inputs[action]=1

  for item in [0..n-1]

    if item > 0
      x += width + margin*2

    if labels[item].length > 1
      fontsize = "58px"
    else
      fontsize = "128px"

    hidden = ( item == 2 )
    button = new Q.UI.Button
      x: x
      y: y
      w: w
      h: h
      z: 1
      hidden: hidden
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      fill: "#c4da4a50"
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize + " Jolly Lodger"
      label: labels[item]         

    if (item == 2)
      # unhide 'fire' button when we've got a gun
      onChangeHidden = (btn) => () =>
        console.log('hidden changed')    
        btn.p.hidden = !Q.state.get("hasGun");

      Q.state.on "change.hasGun", onChangeHidden button
    
    if (dwell_actions[item])
      button.on "click", onClick dwell_actions[item]     
    else
      button.doDwell = false

    if (hover_actions[item])
      button.on "hover", onHover hover_actions[item]      


    stage.insert(button)


