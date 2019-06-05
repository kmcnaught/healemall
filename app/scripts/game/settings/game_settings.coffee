Q = Game.Q
 
Q.scene "game_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Gameplay")

  # layouts
  padding = 0.1
  presets_layout =  stage.insert mainSection.subplot(3,1, 0,0, padding)
  lives_layout = stage.insert mainSection.subplot(3,2, 1,0, padding)
  speed_layout = stage.insert mainSection.subplot(3,2, 2,0, padding)

  # Presets
  preset_names = ["Default", "Relaxed", "Hardcore"]
  n_presets = preset_names.length

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
      label: preset_names[i]
      fontColor: "black"
      font: "400 58px Jolly Lodger"
      h: layout.p.h*.75
      fill: "#c4da4a"
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize + "px Jolly Lodger"
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    

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
    

  Q.CompositeUI.add_adjuster(lives_layout, 'Extra lives', getter, setter, 1, 0, 100)

  # Zombie speed
  getter = () ->
    return Number.parseFloat(Game.settings.zombieSpeed.get())    

  setter = (val) ->
    Game.settings.zombieSpeed.set(val)

  Q.CompositeUI.add_adjuster(speed_layout, 'Zombie speed', getter, setter, 0.05, 0.1, 1.5)
