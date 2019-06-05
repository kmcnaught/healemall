Q = Game.Q
 
Q.scene "sound_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Sounds")

  # layouts
  padding = 0.1
  music_layout  = stage.insert mainSection.subplot(3,1, 0,0, padding)
  fx_layout  = stage.insert mainSection.subplot(3,1, 1,0, padding)
  narration_layout  = stage.insert mainSection.subplot(3,1, 2,0, padding)    

  add_audio_button = (layout, label) -> 
    audioButton = layout.insert new Q.UI.AudioButton        
      isSmall: false

    audioLabel = layout.insert new Q.UI.Text    
      label: label
      color: "#818793"
      family: "Boogaloo"
      size: 36

    label_pad = audioButton.p.w/4
    delta =  audioButton.p.w/2 + audioLabel.p.w/2 + label_pad
    audioLabel.p.x = audioLabel.p.x - delta/2
    audioButton.p.x = audioButton.p.x + delta/2

  add_audio_button music_layout,     "        Music:"
  add_audio_button fx_layout,        " Sound effects:"
  add_audio_button narration_layout, "Game narration:"