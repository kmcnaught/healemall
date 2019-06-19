Q = Game.Q

Q.UI.WarningIcon = Q.Sprite.extend "UI.WarningIcon",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      sheet: "warning"


