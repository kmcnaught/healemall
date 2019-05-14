Q = Game.Q

Q.UI.CursorWarning = Q.UI.Text.extend "UI.CursorWarning",
  init: (p) ->
    @_super p,
      label: "Cursor is currently hidden; to show cursor press 'C'"
      color: "#c4da4a"
      family: "Boogaloo"
      family: "Arial"
      size: 12

    @p.x = Q.width/2
    @p.y = @p.h*.75

    @update_visibility()
    Q.state.on("change.showCursor", @, "update_visibility");

  update_visibility: () ->
    if Q.state.get("showCursor")
      @p.opacity = 0.0
    else
      @p.opacity = 1.0

