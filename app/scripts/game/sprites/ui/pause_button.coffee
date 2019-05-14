Q = Game.Q

Q.UI.PauseButton = Q.UI.Button.extend "UI.PauseButton",
  init: (p) ->
    @_super p,
      x: Q.width - 30
      y: 110
      z: 100
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      keyActionName: "pause" # button that will trigger click event
      isSmall: true
      unpause: false   

    pauseStage = 10   

    if @p.isSmall
      @p.sheet = "hud_pause_button_small"
    else
      @p.sheet = "hud_pause_button"
    
    @size(true) # force resize 

    # Each button will be a "pause button" or an "unpause button"
    # not a toggle
    @on 'click', =>
      if @p.unpause
        Game.trackEvent("Pause Button", "clicked", "off")
        
        if !Game.isMuted
          Q.AudioManager.playAll()

        for stage in Q.stages
          if stage
            stage.unpause()
        
        Q.clearStage(pauseStage)

      else      
        Game.trackEvent("Pause Button", "clicked", "on")

        Q.AudioManager.stopAll()        

        for stage in Q.stages
          if stage
            stage.pause()

        Q.stageScene("paused", pauseStage)


