Q = Game.Q
 
Q.scene "sound_settings", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Sounds")

  # layouts
  padding = 0.1
  music_layout  = stage.insert mainSection.subplot(3,1, 0,0, padding)
  fx_layout  = stage.insert mainSection.subplot(3,1, 1,0, padding)
  narration_layout  = stage.insert mainSection.subplot(3,1, 2,0, padding)    

  add_audio_button = (layout, height, label, sheet) -> 
    audioButton = layout.insert new Q.UI.ToggleButton        
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT      
      do_toggle: true
      btn_sheet: sheet

    gray = "#818793"
    darkgray = "#363738"
    yellow = "#f2da38"

    # Rescale to fit    
    audioButton.p.scale = height/audioButton.p.h
    
    audioLabel = layout.insert new Q.UI.Text    
      label: label
      color: "#818793"
      family: "Boogaloo"
      size: 36

    stateLabel = layout.insert new Q.UI.Text    
      label: "OFF"
      color: gray
      family: "Boogaloo"
      size: 36

    label_pad = audioButton.p.w/4
    delta =  audioButton.p.w/2 + audioLabel.p.w/2 + label_pad
    audioLabel.p.x = audioLabel.p.x - delta/2
    # stateLabel.p.x = stateLabel.p.x + delta/4
    audioButton.p.x = audioButton.p.x + delta/2

    callback = (e) ->
      if audioButton.pressed
        stateLabel.p.color = yellow
        stateLabel.p.label = "ON"
      else
        stateLabel.p.color = gray
        stateLabel.p.label = "OFF"

    audioButton.on "click", callback      

  button_height = music_layout.p.h*0.75
  add_audio_button music_layout,     button_height, "        Music:", "music"
  add_audio_button fx_layout,        button_height, " Sound effects:", "soundfx"
  add_audio_button narration_layout, button_height, "Game narration:", "narration"