Q = Game.Q

Q.Sprite.extend "InfoPoint",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      w: 10*Game.assets.map.tileSize
      h: 10*Game.assets.map.tileSize
      z: 10
      type: Game.SPRITE_PLAYER_COLLECTIBLE
      sensor: true

    @p.y -= @p.h/2 - Game.assets.map.tileSize/2

    # events
    @on "sensor", @, "sensor"

    @already_spoken = false

  sensor: (obj) ->
    if not @already_spoken
      if obj.isA("Player") or obj.isA("ZombiePlayer") 
        if Game.settings.narrationEnabled.get() and @p.label
          responsiveVoice.speak(@p.label);
          @already_spoken = true

