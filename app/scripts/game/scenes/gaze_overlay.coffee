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
            [0.5, 0.15],
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
            [-0.5, 0.15],
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

  # shoot is even lower, to leave centre as rest position
  y_shoot = y_lower + Game.assets.map.tileSize*1.5

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
      button.on "hover", onTouch hover_action
      button.on "touch", onTouch hover_action
      button.on "touchEnd", onTouchEnd hover_action

    return button

  # we want direction+jump arrows to be left-aligned, not centre-aligned
  jump_xoffset = w/30

  btnLeft = createGazeButton(x_left, y_lower, "", leftarrow_p, "", "left")
  btnRight = createGazeButton(x_right, y_lower, "", rightarrow_p, "", "right")
  btnJumpLeft = createGazeButton(x_left+jump_xoffset, y_upper, "", leftjump_p, "jumpleft", "")
  btnJumpRight = createGazeButton(x_right-jump_xoffset, y_upper, "", rightjump_p, "jumpright", "")

  # shoot button has extra logic  
  btnShoot = createGazeButton(x_centre, y_shoot, "shoot", shoot_p, "fire", "")

  # make sure jump buttons haven't gone off top of screen
  min_clearance = 0
  top_of_buttons = btnJumpRight.p.y - btnJumpRight.p.h/2
  if top_of_buttons < min_clearance
    d = min_clearance - top_of_buttons
    btnJumpRight.p.y += d
    btnJumpLeft.p.y += d

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

 