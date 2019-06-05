Q = Game.Q

Q.UI.SettingsButton = Q.UI.Button.extend "UI.SettingsButton",
  init: (p) ->
    @_super p,
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      sheet: "ui_level_button"
      fontColor: "#595f5f"
      font: "400 32px Jolly Lodger"
      # label: "Settings"
      
    @p.sheetW = 172
    @p.sheetH = 130

    @p.cx = @p.sheetW/2
    @p.cy = @p.sheetH/2

    @on 'click', =>
      Game.stageScreen("settings_menu")
#      Game.stageScreen("settingsPlaceholder")
