Q = Game.Q

Q.UI.HelpText = Q.UI.Text.extend "UI.Text",
  init: (p) ->
    @_super p,
      label: ""
      color: "#f2da38"
      family: "Jolly Lodger"
      size: 48

