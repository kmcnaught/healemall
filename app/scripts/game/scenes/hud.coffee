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
  
  scale = 1.0 # TODO: make this a setting

  base_width = Q.width/10
  width = base_width*scale

  w = width
  h = width
  margin = w/15 
  
  onClick = (action) => (e) => 
    if action
      console.log('click %s', action)        
      Q.inputs[action]=1
      Q.input.trigger(action);

  onHover = (action) => (e) => 
    if action
      console.log('hover %s', action)        
      Q.inputs[action]=1


  # define some shapes for the main gaze controls  
  stem_h = h*.275 # varies height of arrow stem (from centre)
  stem_w = w*.05 # varies length of arrow stem (from centre)
  stem_start = w*0.4 # varies how much stem is shrunk to balance the visual weight

  leftarrow_p = [
            [stem_start, -stem_h],
            [-stem_w, -stem_h],
            [-stem_w, -h/2],
            [-w/2, 0],
            [-stem_w, h/2],
            [-stem_w, stem_h],
            [stem_start, stem_h],
          ]   
  rightarrow_p = [
            [-stem_start, stem_h],
            [stem_w, stem_h],
            [stem_w, h/2],
            [+w/2, 0],
            [stem_w, -h/2],
            [stem_w, -stem_h],
            [-stem_start, -stem_h],
          ]
  leftjump_normalised = [
            [0.5, 0.5],
            [0.5, 0.0714285714285715],
            [0.428571428571429, -0.0714285714285714],
            [0.214285714285714, -0.321428571428571],
            [0.428571428571429, -0.5],
            [-0.5, -0.5],
            [-0.5, 0.321428571428571],
            [-0.321428571428571, 0.142857142857143],
            [-0.214285714285714, 0.25],
            [-0.214285714285714, 0.5],
          ]   
  rightjump_normalised = [
            [-0.5, 0.5],
            [-0.5, 0.0714285714285715],
            [-0.428571428571429, -0.0714285714285714],
            [-0.214285714285714, -0.321428571428571],
            [-0.428571428571429, -0.5],
            [0.5, -0.5],
            [0.5, 0.321428571428571],
            [0.321428571428571, 0.142857142857143],
            [0.214285714285714, 0.25],
            [0.214285714285714, 0.5],
          ]  
  # (drew in inkscape, exported points)
  shoot_points_normalised =  [
    [-0.55601, -0.06244],
    [-0.52346, 0.27963],
    [-0.39846, 0.42963],
    [-0.16236, 0.53631],
    [0.13835, 0.53221],
    [0.40483, 0.37777],
    [0.51227, 0.21024],
    [0.56227, 0.06024],
    [0.52017, -0.15927],
    [0.33858, -0.38187],
    [0.0781, -0.50214],
    [-0.21649, -0.44501],
    [-0.44801, -0.29167],
  ]

  # scale shapes up
  shoot_p = ([p[0]*w*.9, p[1]*h*.9] for p in shoot_points_normalised)
  rightjump_p = ([p[0]*w*.9, p[1]*h*.9] for p in rightjump_normalised)
  leftjump_p = ([p[0]*w*.9, p[1]*h*.9] for p in leftjump_normalised)
  
  leftarrow_p = ([p[0]*1.2, p[1]*1.2] for p in leftarrow_p)
  rightarrow_p = ([p[0]*1.2, p[1]*1.2] for p in rightarrow_p)

  button_points = [leftjump_p, leftarrow_p, shoot_p, rightarrow_p, rightjump_p ]               

  # positioning
  # lower buttons (left, right, shoot) should centre vertically on platform player is stood on
  y_lower = Q.height/2 + Game.assets.map.tileSize/2
  # upper buttons (jump) centre just above next platform, for scale = 1, 
  y_upper = y_lower - (3+scale)*Game.assets.map.tileSize 

  camera_offset = -0.4*Game.assets.map.tileSize
  x_left = Q.width/2 + camera_offset - (width + margin*2)
  x_right = Q.width/2 + camera_offset + (width + margin*2)
  x_centre = Q.width/2 + camera_offset

  # define button-adding function
  createGazeButton = (x, y, label, points, dwell_action, hover_action) => 
    button = new Q.UI.PolygonButton
      x: x
      y: y
      w: w
      h: h
      z: 1         
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      fill: "#c4da4a50"
      radius: 10
      fontColor: "#353b47"
      font: "400 58px Jolly Lodger"
      label: label
      points: points

    if (dwell_action)
      button.on "click", onClick dwell_action
    else
      button.doDwell = false

    if (hover_action)
      button.on "hover", onHover hover_action

    return button

  btnLeft = createGazeButton(x_left, y_lower, "", leftarrow_p, "", "left")
  btnRight = createGazeButton(x_right, y_lower, "", rightarrow_p, "", "right")
  btnJumpLeft = createGazeButton(x_left, y_upper, "", leftjump_p, "jumpleft", "")
  btnJumpRight = createGazeButton(x_right, y_upper, "", rightjump_p, "jumpright", "")

  # shoot button has extra logic  
  btnShoot = createGazeButton(x_centre, y_lower, "shoot", shoot_p, "shoot", "")

  # unhide 'fire' button when we've got a gun
  onChangeHidden = (btn) => () =>
    btn.p.hidden = !Q.state.get("hasGun");

  btnShoot.p.hidden = !Q.state.get("hasGun")
  Q.state.on "change.hasGun", onChangeHidden btnShoot

  # Add everything to the stage
  stage.insert(btnLeft)
  stage.insert(btnRight)
  stage.insert(btnJumpLeft)
  stage.insert(btnJumpRight)
  stage.insert(btnShoot)
