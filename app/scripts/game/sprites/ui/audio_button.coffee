Q = Game.Q

Q.UI.AudioButton = Q.UI.Button.extend "UI.AudioButton",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      keyActionName: "mute" # button that will trigger click event
      isSmall: true
      isMuted: false

    @updateSheet()
    @size(true) # force resize 

  updateSheet: () -> 
    if @p.isSmall
        if @p.isMuted
          @p.sheet = "hud_audio_off_button_small"
        else
          @p.sheet = "hud_audio_on_button_small"
      else
        if @p.isMuted
          @p.sheet = "hud_audio_off_button"
        else
          @p.sheet = "hud_audio_on_button"

  setMuted: (isMuted) ->
    @p.isMuted = isMuted
    @updateSheet()

