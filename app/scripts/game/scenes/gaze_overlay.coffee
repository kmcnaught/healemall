Q = Game.Q

Q.scene "gaze_overlay", (stage) ->
  
  scale = Number.parseFloat(Game.settings.uiScale.get())

  base_width = Q.width/10
  width = base_width*scale

  w = width
  h = width
  margin = w/15 
  
  onClick = (action) => (e) => 
    if action
      Q.inputs[action]=1
      Q.input.trigger(action);

  onTouch = (action) => (e) => 
    if action
      Q.inputs[action]=1

  onTouchEnd = (action) => (e) => 
    if action
      Q.inputs[action]=0


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
  # rightjump_p = ([p[0]*w*.9, p[1]*h*.9] for p in rightjump_normalised)
  # leftjump_p = ([p[0]*w*.9, p[1]*h*.9] for p in leftjump_normalised)

  # interact zone for jump buttons is ~90% inside
  # rightjump_p_interact = ([p[0]*.9, p[1]*.9] for p in rightjump_p)
  # leftjump_p_interact = ([p[0]*.9, p[1]*.9] for p in leftjump_p)  

  # positioning
  # lower buttons (left, right, shoot) should centre vertically on platform player is stood on
  y_lower = Q.height/2 + Game.assets.map.tileSize/2

  # shoot is even lower, to leave centre as rest position
  y_shoot = y_lower + Game.assets.map.tileSize*1.5

  # upper buttons (jump) centre just above next platform, for scale = 1, 
  y_upper = y_lower - (3+scale)*Game.assets.map.tileSize 

  camera_offset = -0.4*Game.assets.map.tileSize
  x_left = Q.width/2 + camera_offset - (width + margin*2)
  x_right = Q.width/2 + camera_offset + (width + margin*2)
  x_centre = Q.width/2 + camera_offset
 
  # we want direction+jump arrows to be left-aligned, not centre-aligned
  jump_xoffset = w/30

  btnLeft = new Q.UI.ArrowDwellButton
    x: x_left
    y: y_lower
    h: h
    w: w
    faces_left: true
    hover_action: "left"

  btnRight = new Q.UI.ArrowDwellButton
    x: x_right
    y: y_lower
    w: w
    h: h
    faces_left: false
    hover_action: "right"

  btnJumpLeft = new Q.UI.JumpDwellButton
    x: x_left+jump_xoffset
    y: y_upper
    w: w
    h: h
    faces_left: true
    dwell_action: "jumpleft"

  btnJumpRight = new Q.UI.JumpDwellButton
    x: x_right-jump_xoffset
    y: y_upper
    w: w
    h: h
    faces_left: false
    dwell_action: "jumpright"

  # shoot button 
  btnShoot = new Q.UI.PolygonButton
    x: x_centre
    y: y_shoot
    w: w
    h: h
    z: 1         
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: "shoot"
    points: shoot_p

  btnShoot.p.opacity = Number.parseFloat(Game.settings.uiOpacity.get())

  btnShoot.on "click", (e) -> 
    Q.inputs["fire"]=1
    Q.input.trigger("fire");

  # unhide 'fire' button when we've got a gun
  onChangeHidden = (btn) => () =>
    btn.p.hidden = !Q.state.get("hasGun");

  btnShoot.p.hidden = !Q.state.get("hasGun")
  Q.state.on "change.hasGun", onChangeHidden btnShoot

  # make sure jump buttons haven't gone off top of screen
  min_clearance = 0
  top_of_buttons = btnJumpRight.p.y - btnJumpRight.p.h/2
  if top_of_buttons < min_clearance
    d = min_clearance - top_of_buttons
    btnJumpRight.p.y += d
    btnJumpLeft.p.y += d

  # Add everything to the stage
  stage.insert(btnLeft)
  stage.insert(btnRight)
  stage.insert(btnJumpLeft)
  stage.insert(btnJumpRight)
  stage.insert(btnShoot)

 