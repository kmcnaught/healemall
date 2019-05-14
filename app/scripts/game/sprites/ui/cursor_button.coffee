Q = Game.Q

Q.UI.CursorButton = Q.UI.Button.extend "UI.CursorButton",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      keyActionName: "show_cursor" # button that will trigger click event
      isSmall: true

    @update_sheet(p)
    @size(true) # force resize 

    Q.state.on("change.showCursor", @, "update_sheet");

    @on 'click', =>
      Game.toggleCursor()      

  update_sheet: () ->

    if @p.isSmall
      if Q.state.get("showCursor")
        @p.sheet = "hud_cursor_on_button_small"
      else
        @p.sheet = "hud_cursor_off_button_small"
    else
      if Q.state.get("showCursor")
        @p.sheet = "hud_cursor_on_button"
      else
        @p.sheet = "hud_cursor_off_button"

 
