Q = Game.Q
 
Q.scene "game_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Gameplay")

    
  # layouts
  padding = 0.1
  presets_layout =  stage.insert mainSection.subplot(3,1, 0,0, padding)
  lives_layout = stage.insert mainSection.subplot(3,2, 1,0, padding)
  speed_layout = stage.insert mainSection.subplot(3,2, 2,0, padding)
  chase_layout = stage.insert mainSection.subplot(3,4, 1,2, padding)
  gun_layout = stage.insert mainSection.subplot(3,4, 1,3, padding)
  ammo_layout = stage.insert mainSection.subplot(3,4, 2,2, padding)


  # Lives
  getter = () ->
    return Number.parseInt(Game.settings.lives.get())    

  setter = (val) ->
    # jump in bigger increments at higher numbers    
    if val == 11
      Game.settings.lives.set(20)
    else if val == 19    
      Game.settings.lives.set(10)
    else if val == 21
      Game.settings.lives.set(50)
    else if val == 49
      Game.settings.lives.set(20)
    else if val == 51
      Game.settings.lives.set(100)
    else if val == 99
      Game.settings.lives.set(50)      
    else
      Game.settings.lives.set(val)
    

  update_lives = Q.CompositeUI.add_adjuster(lives_layout, 'Spare lives', getter, setter, 1, 0, 100)

  # Zombie speed
  getter = () ->
    return Number.parseFloat(Game.settings.zombieSpeed.get())    

  setter = (val) ->
    Game.settings.zombieSpeed.set(val)

  update_zombieSpeed = Q.CompositeUI.add_adjuster(speed_layout, 'Zombie speed', getter, setter, 0.05, 0.1, 1.5)

  # Other options
  chkChase = Q.CompositeUI.add_checkbox(chase_layout, "Zombies\nchase you", (checked) -> Game.settings.zombiesChase.set(checked))
  chkGun = Q.CompositeUI.add_checkbox(gun_layout, "Start with\ngun", (checked) -> Game.settings.startWithGun.set(checked))
  chkAmmo = Q.CompositeUI.add_checkbox(ammo_layout, "Unlimited\nammo", (checked) -> Game.settings.unlimitedAmmo.set(checked))
  
  # Presets, need to update all the other settings

  update_all = () ->
    chkChase.checked = Game.settings.zombiesChase.get()
    chkGun.checked = Game.settings.startWithGun.get()
    chkAmmo.checked = Game.settings.unlimitedAmmo.get()  
    update_lives(Game.settings.lives.get())
    update_zombieSpeed(Game.settings.zombieSpeed.get())

  # Make sure we start reflecting correct state
  update_all() 

  # Background panel to hold elements together visually    
  panel = presets_layout.insert new Q.UI.Container      
    fill: "#e3ecf933",      
    radius: 12,
    w: presets_layout.p.w
    h: presets_layout.p.h
    # type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  presets = [
    {
      name: "Relaxed"
      lives: 100
      zombieSpeed: 0.5      
      zombiesChase: false
      unlimitedAmmo: true
      startWithGun: true
    },
    {
      name: "Default"
      lives: 3
      zombieSpeed: 1.0      
      zombiesChase: true
      unlimitedAmmo: false
      startWithGun: false
    },    
    {
      name: "Hardcore"
      lives: 0
      zombieSpeed: 1.0
      zombiesChase: true
      unlimitedAmmo: false
      startWithGun: false
    }
  ]
  n_presets = presets.length

  preset_label_layout = stage.insert presets_layout.subplot(1,n_presets+1,0,0)
  preset_label = preset_label_layout.insert new Q.UI.Text    
      label: "Presets:"
      color: "#363738"
      family: "Boogaloo"
      size: 36

  for i in [0..n_presets-1]
  # for label in preset_names
    layout = stage.insert presets_layout.subplot(1,n_presets+1,0,i+1)
    fontsize = Math.floor(layout.p.h/3)
    btn = layout.insert new Q.UI.Button
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      label: presets[i].name
      fontColor: "black"
      font: "400 58px Jolly Lodger"
      h: layout.p.h*.75
      fill: "#c4da4a"
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize + "px Jolly Lodger"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    
    callback = (i) -> () ->            
      Game.settings.lives.set(presets[i].lives)    
      Game.settings.zombieSpeed.set(presets[i].zombieSpeed)    
      Game.settings.zombiesChase.set(presets[i].zombiesChase)
      Game.settings.unlimitedAmmo.set(presets[i].unlimitedAmmo)
      Game.settings.startWithGun.set(presets[i].startWithGun)
      update_all()
      
    btn.on "click", callback(i)