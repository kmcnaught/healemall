Q = Game.Q

Q.UI.Checkbox = Q.UI.Button.extend "UI.Checkbox",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      checked: false
      sheet: "checkbox"
     
    @size(true) # force resize     

    @on 'click', =>
      @checked = !@checked

  draw: (ctx) ->
    @_super(ctx)

    # Q.sheet("checkbox").draw(ctx, -@p.cx, -@p.cy, @p.frame);
    if @checked  
      Q.sheet("checkbox_checked").draw(ctx, -@p.cx, -@p.cy, @p.frame);
    