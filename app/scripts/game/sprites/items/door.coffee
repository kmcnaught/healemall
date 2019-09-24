Q = Game.Q

Q.Sprite.extend "Door",
  init: (p) ->
    @_super p,
      x: 0
      y: 0
      z: 10
      sheet: "door_closed"
      opened: false
      type: Game.SPRITE_PLAYER_COLLECTIBLE
      sensor: true

    @p.y -= @p.h/2 - Game.assets.map.tileSize/2

    # events
    @on "sensor", @, "sensor"

  sensor: (obj) ->
    if obj.isA("Player") or obj.isA("ZombiePlayer") 
      if (Q.state.get "hasKey") && !@p.opened
        # remove the key and open the door
        Q.state.set "hasKey", false
        @p.opened = true
        @p.sheet = "door_open"
        Q.state.set "canEnterDoor", true

        Game.infoLabel.doorOpen()

      else if !@p.opened
        Game.infoLabel.keyNeeded()

      else if @p.opened and (Q.inputs['up'] or Q.inputs['action'] or Q.inputs['enter'])
        # enter the door
        obj.destroy()

        Q.inputs['enter'] = 0

        # get game statistics
        Game.currentLevelData.zombies.healed = if @stage.lists.Human? then @stage.lists.Human.length else 0

        if Q.state.get("currentLevel") > 0
          Game.stageEndLevelScreen()
        else
          Q.clearStages()
          Q.stageScene "tutorialSummary", Game.currentLevelData
          Game.currentScreen = "tutorialSummary"

          

