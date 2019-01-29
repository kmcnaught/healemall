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
  stage.insert new Q.UI.PauseButton()
  stage.insert new Q.UI.MenuButton()

  # gaze controls  
  n = 5
  labels = ['jump', '<', '', '>', 'jump']
  actions = ['jumpleft', 'left', '', 'right', 'jumpright']
  width = Q.width/12
  margin = width/10  

  w = width
  h = width

  x = (Q.width - n*(width+margin))/2
  y = Q.height - width - margin*2


  onClick = (action) => (e) => 
    console.log('click %s', action)        
    Q.inputs[action]=1

  onRelease = (action) => (e) => 
    console.log('release %s', action)        
    Q.inputs[action]=0

  for item in [0..n-1]

    if item > 0
      x += width + margin*2

    if item == 2
      continue

    if labels[item].length > 1
      fontsize = "58px"
    else
      fontsize = "128px"

    button = new Q.UI.Button
      x: x
      y: y
      w: w
      h: h
      z: 1
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      fill: "#c4da4a80"
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize + " Jolly Lodger"
      label: labels[item]
      keyActionName: "fire"
    
    button.on "click", onClick actions[item]
      
    button.on "release", onRelease actions[item]


    stage.insert(button)


