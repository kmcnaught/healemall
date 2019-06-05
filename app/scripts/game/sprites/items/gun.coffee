Q = Game.Q

Q.Sprite.extend "Gun",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      z: 10
      sheet: "gun"
      type: Game.SPRITE_PLAYER_COLLECTIBLE
      sensor: true
      bullets: 6

    @p.y -= 15

    # events
    @on "sensor", @, "sensor"

  sensor: (obj) ->
    if obj.isA("Player")
      if Q.state.get("hasGun")
        Game.infoLabel.moreBullets()
      else  
        Q.state.set "hasGun", true
        obj.add("gun")
        Game.infoLabel.gunFound()

      # number of bullets depends of the gun
      Q.state.inc "bullets", @p.bullets
      Game.currentLevelData.bullets.available = Q.state.get("bullets")

      Q.AudioManager.addSoundFx Game.audio.collected
      @destroy()


