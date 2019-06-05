Q = Game.Q

Q.component "gun",
  added: ->
    Q.input.on("fire", @entity, "fireGun")
    p = @entity.p

    # animations
    p.sheet = "player_with_gun"
    p.sprite = "playerWithGun"
    @entity.play("stand")

    # do not allow to fire in series
    p.nextFireTimeout = 0

  destroyed: ->
    Q.input.off("fire", @entity)

  extend:
    gunStep: (dt) ->
      if @p.nextFireTimeout > 0
        @p.nextFireTimeout = Math.max(@p.nextFireTimeout - dt, 0)

    fireGun: ->
      if @p.nextFireTimeout == 0
        @p.nextFireTimeout = 0.5

        # fire
        if Q.state.get("bullets") > 0

          if @p.direction == "left"
            delta = -15
          else
            delta = 15

          Q.AudioManager.addSoundFx Game.audio.gunShot

          bullet = @stage.insert new Q.Bullet
            x: @p.x + delta
            y: @p.y + 3
            direction: @p.direction        

          # update counter
          if not Game.settings.unlimitedAmmo.get()
            Q.state.dec "bullets", 1

        else
          Game.infoLabel.outOfBullets()
