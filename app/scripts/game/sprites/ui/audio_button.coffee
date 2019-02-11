Q = Game.Q

Q.UI.AudioButton = Q.UI.Button.extend "UI.AudioButton",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      keyActionName: "mute" # button that will trigger click event
      isSmall: true

    if @p.isSmall
      if Game.isMuted
        @p.sheet = "hud_audio_off_button_small"
      else
        @p.sheet = "hud_audio_on_button_small"
    else
      if Game.isMuted
        @p.sheet = "hud_audio_off_button"
      else
        @p.sheet = "hud_audio_on_button"

    @size(true) # force resize 

    @on 'click', =>
      if !Game.isMuted
        Q.AudioManager.mute()
        if @p.isSmall
          @p.sheet = "hud_audio_off_button_small"
        else
          @p.sheet = "hud_audio_off_button"
        Game.isMuted = true

        Game.trackEvent("Audio Button", "clicked", "off")

      else
        Q.AudioManager.unmute()
        if @p.isSmall
          @p.sheet = "hud_audio_on_button_small"
        else
          @p.sheet = "hud_audio_on_button"          
        Game.isMuted = false

        Game.trackEvent("Audio Button", "clicked", "on")

