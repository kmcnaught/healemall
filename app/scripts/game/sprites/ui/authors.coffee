Q = Game.Q

Q.UI.Authors = Q.UI.Text.extend "UI.Authors",
  init: (p) ->
    @_super p,
      label: "Created by @krzysu and @pawelmadeja, extended and adapted for eye gaze by @SpecialEffect"
      color: "#c4da4a"
      family: "Boogaloo"
      size: 22

    @p.x = Q.width/2
    @p.y = Q.height - @p.h/2

