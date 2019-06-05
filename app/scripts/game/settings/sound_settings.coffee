Q = Game.Q
 
Q.scene "sound_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Sounds")

  # layouts
  padding = 0.1
  music_layout  = stage.insert mainSection.subplot(3,1, 0,0, padding)
  fx_layout  = stage.insert mainSection.subplot(3,1, 1,0, padding)
  narration_layout  = stage.insert mainSection.subplot(3,1, 2,0, padding)
    
