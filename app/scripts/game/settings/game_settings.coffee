Q = Game.Q
 
Q.scene "game_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Gameplay")

  # layouts
  padding = 0.1
  presets_layout =  stage.insert mainSection.subplot(3,1, 0,0, padding)
  lives_layout = stage.insert mainSection.subplot(3,2, 1,0, padding)
  speed_layout = stage.insert mainSection.subplot(3,2, 2,0, padding)



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
    

  update_lives = Q.CompositeUI.add_adjuster(lives_layout, 'Extra lives', getter, setter, 1, 0, 100)

  # Zombie speed
  getter = () ->
    return Number.parseFloat(Game.settings.zombieSpeed.get())    

  setter = (val) ->
    Game.settings.zombieSpeed.set(val)

  update_zombieSpeed = Q.CompositeUI.add_adjuster(speed_layout, 'Zombie speed', getter, setter, 0.05, 0.1, 1.5)

  # Other options




  # Presets
  presets = [
    {
      name: "Default"
      lives: 3
      zombieSpeed: 1.0      
      zombiesChase: true
    },
    {
      name: "Relaxed"
      lives: 100
      zombieSpeed: 0.5      
      zombiesChase: false
    },
    {
      name: "Hardcore"
      lives: 0
      zombieSpeed: 1.0
      zombiesChase: true
    }
  ]
  n_presets = presets.length

  preset_label_layout = stage.insert presets_layout.subplot(1,n_presets+1,0,0)
  preset_label = preset_label_layout.insert new Q.UI.Text    
      label: "Presets:"
      color: "#818793"
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
      if presets[i].lives?
        update_lives(presets[i].lives)
      if presets[i].zombieSpeed?
        update_zombieSpeed(presets[i].zombieSpeed)
      if presets[i].zombiesChase?
        Game.settings.zombiesChase.set(presets[i].zombiesChase)
    
    btn.on "click", callback(i)