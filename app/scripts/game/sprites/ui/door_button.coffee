Q = Game.Q

Q.UI.DoorButton = Q.UI.Button.extend "UI.DoorButton",

  init: (p) ->
    @_super p,
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT      
      w: 120
      h: 120
      hidden: true
      fill: "#c4da4a"
      radius: 10
      fontColor: "#353b47"
      font: "400 58px Jolly Lodger"
      label: "enter"      
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

    if @p.enabled == false
      @p.sheet = "ui_level_button_locked"
      @p.label = false

    @on "click", (e) ->
      Q.inputs['enter']=1
      Q.input.trigger('enter');

    # @on "release", (e) ->
    #   Q.inputs['enter']=0

    onChangeHidden = (ctx) => () =>
      ctx.p.hidden = !Q.state.get("canEnterDoor");

    Q.state.on "change.canEnterDoor", onChangeHidden @
      


