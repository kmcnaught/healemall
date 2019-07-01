Q = Game.Q

Q.UI.ArrowButton = Q.UI.Button.extend "UI.ArrowButton",
  init: (p) ->
    @_super p,
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      sheet: "arrow_button"
      fontColor: "#595f5f"
      font: "400 32px Jolly Lodger"
      page: 0
      fontColor: "#404444"
      align: 'center'
      flip: false
      
    @p.sheetW = 172
    @p.sheetH = 130

    @p.cx = @p.sheetW/2
    @p.cy = @p.sheetH/2

    if not @p.enabled
      @p.opacity = 0.4

    @on 'click', =>
      if @p.enabled
        Game.stageMoreLevels(@p.page)
