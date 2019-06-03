Q = Game.Q

Q.UI.ToggleButton = Q.UI.Button.extend "UI.ToggleButton",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      pressed: false
      sheet: "button_not_pressed"
      do_toggle: false
     
    @size(true) # force resize     

    if @p.do_toggle
      @on 'click', =>
        @pressed = !@pressed

  draw: (ctx) ->
    @_super(ctx)

    if @p.btn_sheet
      sheet = Q.sheet(@p.btn_sheet)
      w = sheet.tileW
      h = sheet.tileH
      sheet.draw(ctx, -@p.cx + (@p.w-w)/2, -@p.cy + (@p.h-h)/2, @p.frame);

    if @pressed  
      Q.sheet("button_pressed").draw(ctx, -@p.cx, -@p.cy, @p.frame);
    else
      # we redraw this on top of button icons as a form of greying out
      Q.sheet("button_not_pressed").draw(ctx, -@p.cx, -@p.cy, @p.frame);