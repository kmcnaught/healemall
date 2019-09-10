Q = Game.Q
 
Q.scene "settings_menu", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Settings")

  padding = 0.1
  controls_layout  = stage.insert mainSection.subplot(2,2, 0,0, padding)
  game_layout  = stage.insert mainSection.subplot(2,2, 0,1, padding)
  sound_layout  = stage.insert mainSection.subplot(2,2, 1,0, padding)
  reset_layout  = stage.insert mainSection.subplot(2,2, 1,1, padding)
  
  controls_text = "Controls"
  gameplay_text = "Gameplay"
  sounds_text = "Sounds"

  textsize = Q.ctx.measureText(gameplay_text)
  button_width = textsize.width

  add_button = (layout, label, page) ->
    
    buttonTextSize = Q.ctx.measureText(label)
    fontsize = Math.floor(layout.p.h/3)      

    button = layout.insert new Q.UI.Button
      w: button_width*1.3
      h: layout.p.h*.75
      fill: "#c4da4a"
      radius: 10
      fontColor: "#353b47"
      font: "400 " + fontsize + "px Jolly Lodger"
      label: label
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
    
    button.on "click", (e) =>
      console.log(page) 
      Game.stageScreen(page)
  
  # These buttons share setup code
  add_button controls_layout, controls_text, "controls_settings"
  add_button game_layout, gameplay_text, "game_settings"
  add_button sound_layout, sounds_text, "sound_settings"

  # Reset button is special case
  fontsize = Math.floor(reset_layout.p.h/5)    
  Q.ctx.font = "400 " + fontsize + "px Jolly Lodger"
  reset_text = "Reset all"

  textsize = Q.ctx.measureText(reset_text)
  button_width = textsize.width

  button = reset_layout.insert new Q.UI.Button
    w: button_width*1.3
    h: reset_layout.p.h*.25
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 " + fontsize + "px Jolly Lodger"
    label: reset_text
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT  

  button.on "click", (e) =>
    console.log("Reset!!") 
    Game.stageScreen("confirm_reset")
    