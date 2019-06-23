Q = Game.Q

Q.UI.MenuButton = Q.UI.Button.extend "UI.MenuButton",
  init: (p) ->
    @_super p,
      x: Q.width - 30
      y: 170
      z: 100
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      keyActionName: "escape" # button that will trigger click event
      isSmall: true

    if @p.isSmall
      @p.sheet = "hud_back_button_small"
    else
      @p.sheet = "hud_back_button"

    @size(true) # force resize 
