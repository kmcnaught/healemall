Q = Game.Q
 
Q.scene "settings_menu", (stage) ->

  # settings page structure
  [titleBar, mainSection, buttonBar] = Q.CompositeUI.setup_settings_page(stage, "Settings")

  padding = 0.1
  controls_layout  = stage.insert mainSection.subplot(2,2, 0,0, padding)
  game_layout  = stage.insert mainSection.subplot(2,2, 0,1, padding)
  sound_layout  = stage.insert mainSection.subplot(2,2, 1,0, padding)
  
  controls_layout

  add_button = (layout, label, page) ->
    
    buttonTextSize = Q.ctx.measureText(label)
    fontsize = Math.floor(layout.h/5)      

    button = layout.insert new Q.UI.Button
      w: buttonTextSize.width*1.3
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
      
  add_button controls_layout, "Controls", "controls_settings"
  add_button game_layout, "Gameplay", "game_settings"
  add_button sound_layout, "Sounds", "sound_settings"

