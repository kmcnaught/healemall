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

    @on 'click', =>

      if !Game.showCursor
        element = document.getElementById("quintus_container")
        element.style.cursor = "auto"

        Game.showCursor = true

        Game.trackEvent("Cursor Button", "clicked", "off")

      else
        element = document.getElementById("quintus_container")
        element.style.cursor = "none"
  
        Game.showCursor = false

        Game.trackEvent("Cursor Button", "clicked", "on")

      @update_sheet()

      # Remember response in local storage
      localStorage.setItem(Game.storageKeys.showCursor, Game.showCursor)

  update_sheet: () ->

    if @p.isSmall
      if Game.showCursor
        @p.sheet = "hud_cursor_on_button_small"
      else
        @p.sheet = "hud_cursor_off_button_small"
    else
      if Game.showCursor
        @p.sheet = "hud_cursor_on_button"
      else
        @p.sheet = "hud_cursor_off_button"

 
