Q = Game.Q

Q.component "zombieAI",
  added: ->
    p = @entity.p
    p.fullSpeed = 60*Game.settings.zombieSpeed.get()

    if p.startLeft
      p.vx = p.fullSpeed
    else
      p.vx = -p.fullSpeed

    p.audioTimeout = 0

  extend:
    zombieStep: (dt) ->
      # some AI - always try to catch player
      @canSeeThePlayer() # create @canSeeThePlayerObj object

      # stop chasing while player invincible
      playerInvincible = @isPlayerInvincible()
      if playerInvincible
        @p.canSeeThePlayerTimeout = 0
      else if @canSeeThePlayerObj.status
        # I see the player, I will remember that for X sec
        @p.canSeeThePlayerTimeout = 2

        if @canSeeThePlayerObj.playAudio
          if @p.audioTimeout == 0
            Q.AudioManager.addSoundFx Game.audio.zombieNotice
            @play("attack", 10)
            @p.audioTimeout = 10

        if (@canSeeThePlayerObj.left and @p.vx > 0) or (@canSeeThePlayerObj.right and @p.vx < 0)
          # enemy goes in wrong direction, change it
          @p.vx = -Math.sign(@p.vx)*@p.fullSpeed
      else
        # run timeout
        @p.canSeeThePlayerTimeout = Math.max(@p.canSeeThePlayerTimeout - dt, 0)

      # count always
      @p.audioTimeout = Math.max(@p.audioTimeout - dt, 0)

      # locate gap and turn back
      dirX = @p.vx/Math.abs(@p.vx) # or Math.sign(@p.vx) !
      ground = Q.stage().locate(@p.x, @p.y + @p.h/2 + 1, Game.SPRITE_TILES)
      nextTile = Q.stage().locate(@p.x + dirX * @p.w/2 + dirX, @p.y + @p.h/2 + 1, Game.SPRITE_TILES)      
      inFrontTile = Q.stage().locate(@p.x + dirX * @p.w/2 + dirX, @p.y, Game.SPRITE_TILES)
      inFrontPlayer =  Q.stage().locate(@p.x + dirX * @p.w/2 + dirX, @p.y, Game.SPRITE_PLAYER)
      inFront = inFrontTile or inFrontPlayer

      cliffAhead = !nextTile and ground

      # if player is invincible, we'll stop chasing as soon as attack animation finished
      stopChasing = playerInvincible and @p.animation != "attack"
      currentlyChasing = not stopChasing and (@canSeeThePlayerObj.status or @p.canSeeThePlayerTimeout > 0)

      if cliffAhead 
        if not currentlyChasing 
          if @p.vx > 0
            # turn around 
            @p.vx = -Math.sign(@p.vx)*@p.fullSpeed
          else
            # turn around 
            if @p.flip
              @p.vx = @p.fullSpeed
            else
              @p.vx = -@p.fullSpeed
        else if currentlyChasing and not @p.canFallOff
          # keep facing player, but don't fall off
          @p.vx = 0

      # if there's an obstacle in front
      if (inFront and !currentlyChasing)
        # turn around 
        @p.vx = -Math.sign(@p.vx)*@p.fullSpeed

      # set the correct direction of sprite
      @flip()

    flip: ->
      if Math.abs(@p.vx) > 0
        if(@p.vx > 0)
          @p.flip = false
        else
          @p.flip = "x"

    isPlayerInvincible: ->
      player = Game.player.p
      return (not player?.isDestroyed? and player.timeInvincible > 0)

    canSeeThePlayer: ->
      player = Game.player.p
      lineOfSight = 350

      oldObj = @canSeeThePlayerObj

      @canSeeThePlayerObj =
        playAudio: true
        status: false

      # If chasing is turned off, don't look for the player      
      if !Game.settings.zombiesChase.get()
        return

      if oldObj?.status == true
        @canSeeThePlayerObj.playAudio = false

      if Game.player.isDestroyed?
        return

      # is player on the same level as enemy?
      isTheSameY = player.y > @p.y - 10 and player.y < @p.y + 10

      # is player in the near of the enemy?
      @canSeeThePlayerObj.left = isCloseFromLeft = (player.x > @p.x - lineOfSight) and player.x < @p.x
      @canSeeThePlayerObj.right = isCloseFromRight = (player.x < @p.x + lineOfSight) and player.x > @p.x

      if isTheSameY and (isCloseFromLeft or isCloseFromRight)
        @canSeeThePlayerObj.status = true
      else
        @canSeeThePlayerObj.status = false
        @canSeeThePlayerObj.playAudio = true

      return
