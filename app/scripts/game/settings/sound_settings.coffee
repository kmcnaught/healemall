Q = Game.Q
 
Q.scene "sound_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Sounds")

  # layouts
  padding = 0.1
  music_layout  = stage.insert mainSection.subplot(3,2, 0,0, padding)
  fx_layout  = stage.insert mainSection.subplot(3,2, 1,0, padding)
  narration_layout  = stage.insert mainSection.subplot(3,2, 2,0, padding)    

  # Callbacks
  music_callback = (is_pressed) ->
    Game.settings.musicEnabled.set(is_pressed)

  soundfx_callback = (is_pressed) ->
    Game.settings.soundFxEnabled.set(is_pressed)  

  narrate_callback = (is_pressed) ->
    Game.settings.narrationEnabled.set(is_pressed)  

  # Checkboxes
  chk_music = Q.CompositeUI.add_checkbox(music_layout, "Music", music_callback)
  chk_sfx = Q.CompositeUI.add_checkbox(fx_layout, "Sound effects", soundfx_callback)
  chk_narration = Q.CompositeUI.add_checkbox(narration_layout, "Narration", narrate_callback)

  # Initial checkbox state
  chk_music.checked = Game.settings.musicEnabled.get()
  chk_sfx.checked = Game.settings.soundFxEnabled.get()
  chk_narration.checked = Game.settings.narrationEnabled.get()

  # Align all check boxes
  leftmost_x = 0
  leftmost_x = Math.min(leftmost_x, chk_music.p.x)
  leftmost_x = Math.min(leftmost_x, chk_sfx.p.x)
  leftmost_x = Math.min(leftmost_x, chk_narration.p.x)

  chk_music.p.x = leftmost_x
  chk_sfx.p.x = leftmost_x
  chk_narration.p.x = leftmost_x