

class Storage 
  # Store some user stuff in local or session storage

  constructor: ->
    console.log('storage constructor')
   
    @prefix = "zombiegame:"  
    @storage = localStorage # TODO: revert to sessionStorage if permission denied 
    
    @storageKeys = 
      availableLevel: @prefix + "availableLevel"
      levelProgress: @prefix + "levelProgress"
      showCursor: @prefix + "showCursor"

    getBoolValue = (key) => 
      stringVal = @storage.getItem(key)
      return true.toString() == stringVal

    isNull = (key) =>
      stringVal = @storage.getItem(key)
      return stringVal == null

    setAvailableLevel = (level) =>
      @storage.setItem(@storageKeys.availableLevel, level)

    setShowCursor = (show_cursor) =>
      @storage.setItem(@storageKeys.showCursor, show_cursor)

    # Populate
    if isNull(@storageKeys.availableLevel)
      setAvailableLevel(1)

    if isNull(@storageKeys.showCursor)
      setShowCursor(true)

    Game.availableLevel = @storage.getItem(@storageKeys.availableLevel)
    Game.showCursor = @storage.getItem(@storageKeys.showCursor)
    Game.moreLevelsPage = 0


# main game object
window.Game =
  init: ->
    # engine instance
    @Q = Q = Quintus
      development: true
      audioSupported: [ 'ogg', 'mp3' ]

    # Q.debug = true
    # Q.debugFill = true

    # main setup
    Q.include "Sprites, Scenes, Input, Touch, Gaze, UI, 2D, Anim, Audio"
    Q.setup
      # width: 640
      # height: 320
      maximize: true
      upsampleWidth: 640
      upsampleHeight: 320
    Q.controls().touch(Q.SPRITE_UI, [0,1])
    Q.controls().trackGaze(Q.SPRITE_UI, [0,1,2])
    Q.enableSound()

    # game progress
    Game.storageKeys =
      availableLevel: "zombieGame:availableLevel"
      levelProgress: "zombieGame:levelProgress"
      showCursor: "zombieGame:showCursor"
      unlockedBonus: "zombieGame:unlockedBonus"

    Game.availableLevel = localStorage.getItem(Game.storageKeys.availableLevel) || 1
    
    boolValueOrDefault = (key, defaultVal) =>
      stringVal = localStorage.getItem(key)
      if (stringVal == null)
        return defaultVal
      else
        if (stringVal == false.toString())
          return false
        else if (stringVal == true.toString())
          return true
        else
          console.error("Cannot read bool value for key #{key}")
          return defaultVal
    
    Game.showCursor = boolValueOrDefault(Game.storageKeys.showCursor, true)
    Game.unlockedBonus = boolValueOrDefault(Game.storageKeys.unlockedBonus, false)

    # used for collision detection
    @SPRITE_NONE = 0
    @SPRITE_PLAYER = 1
    @SPRITE_TILES = 2
    @SPRITE_ENEMY = 4
    @SPRITE_BULLET = 8
    @SPRITE_PLAYER_COLLECTIBLE = 16
    @SPRITE_HUMAN = 32
    @SPRITE_ZOMBIE_PLAYER = 64
    @SPRITE_ALL = 0xFFFF

    # rest of init
    @prepareAssets()
    @initStats()
    @initUnloadEvent()

    # helpers
    Q.tilePos = (col, row, otherParams = {}) ->
      position =
        x: col * Game.assets.map.tileSize + Game.assets.map.tileSize/2
        y: row * Game.assets.map.tileSize + Game.assets.map.tileSize/2

      Q._extend position, otherParams

    if not Game.showCursor
      element = document.getElementById("quintus_container")
      element.style.cursor = "none"

    return

  # one place of defining assets
  prepareAssets: ->

    levels = 
      tutorial:
        dataAsset: "tutorial.tmx"
        bullets: 20
      level1:
        dataAsset: "level1.tmx"
        bullets: 4
      level2:
        dataAsset: "level2.tmx"
        bullets: 8
      level3:
        dataAsset: "level3.tmx"
        bullets: 6
      level4:
        dataAsset: "level4.tmx"
        bullets: 3
      level5:
        dataAsset: "level5.tmx"
        bullets: 15
      level6:
        dataAsset: "level6.tmx"
        bullets: 3
      level7:      
        dataAsset: "level7.tmx"
        bullets: 10
        name:"Easy Peasy"
      level8:
        dataAsset: "level8.tmx"
        bullets: 10
        name: "Too Many Zombies"
      level9:
        dataAsset: "level9.tmx"
        bullets: 10
        name: "Tricky"
      level10:
        dataAsset: "level10.tmx"
        bullets: 10
        name: 'Really long name here'
      level11:
        dataAsset: "level11.tmx"
        bullets: 10
      level12:
        dataAsset: "level12.tmx"
        bullets: 10
      level13:
        dataAsset: "level13.tmx"
        bullets: 10
      level14:
        dataAsset: "level14.tmx"
        bullets: 10
      level15:
        dataAsset: "level15.tmx"
        bullets: 10
      level16:
        dataAsset: "level16.tmx"
        bullets: 10
      level17:
        dataAsset: "level17.tmx"
        bullets: 10
      level18:
        dataAsset: "level18.tmx"
        bullets: 10
      level19:
        dataAsset: "level19.tmx"
        bullets: 10
      level20:
        dataAsset: "level20.tmx"
        bullets: 10

    # split into array for accessing level details by index
    # and data assets strings for loading 
    @levels_array = []
    level_assets = []  
    for k, v of levels
      @levels_array.push v
      level_assets.push v.dataAsset

    # all assets, only file names
    @assets =
      characters:
        dataAsset: "characters.json"
        sheet: "characters.png"
      controls:
        dataAsset: "controls.json"
        sheet: "controls.png"
      items:
        dataAsset: "items.json"
        sheet: "items.png"
      hud:
        dataAsset: "hud.json"
        sheet: "hud.png"
      others:
        dataAsset: "others.json"
        sheet: "others.png"
      misc:
        dataAsset: "misc.json"
        sheet: "misc.png"
      bullet:
        dataAsset: "bullet.json"
        sheet: "bullet.png"
      map:
        sheet: "map_tiles.png"
      gradient: "gradient-top.png"
      tutorial:
        dataAsset: "tutorial.tmx"
      
    # audio
    @audio =
      zombieMode: "zombie_mode.mp3"
      playerBg: "player_bg.mp3"
      zombieNotice: "zombie_notice.mp3"
      gunShot: "gun_shot.mp3"
      collected: "collected.mp3"
      playerHit: "player_hit.mp3"
      humanCreated: "human_created.mp3"

    Game.isMuted = false

    # convert to array for Q.load    
    assetsAsArray = []
    @objValueToArray(@assets, assetsAsArray)

    # now we can add metadata
    @assets.map.sheetName = "tiles"
    @assets.map.tileSize = 70

    # convert @audio to array
    audioAsArray = []
    @objValueToArray(@audio, audioAsArray)

    # merge assets and audio for Q.load
    @assets.all = assetsAsArray.concat(audioAsArray).concat(level_assets)

  # helper to conver obj to array
  objValueToArray: (obj, array) ->
    for key, value of obj
      if typeof value == 'string'
        array.push value
      else
        @objValueToArray(value, array)

  initStats: ->
    @Q.stats = stats = new Stats()
    stats.setMode(0) # 0: fps, 1: ms

    # Align top-left
    # stats.domElement.style.position = 'absolute'
    # stats.domElement.style.left = '0px'
    # stats.domElement.style.top = '140px'

    # document.body.appendChild( stats.domElement )

  stageLevel: (number = 1) ->
    Q = @Q

    Q.state.reset
      enemiesCounter: 0
      lives: 5
      bullets: 0
      hasKey: false
      hasGun: false
      currentLevel: number # for saving the progress
      canEnterDoor: false

    Game.currentLevelData = # for level summary
      zombies:
        healed: 0
        available: 0
      health:
        collected: 0
        available: 0
      bullets:
        waisted: 0
        available: 0
      zombieModeFound: false

    Q.input.touchControls() # render onscreen touch buttons

    Q.clearStages()

    level = Game.levels_array[number]

    # levels are constructed on the fly
    level_data =level.dataAsset
    num_bullets = level.bullets

    Q.scene "level", (stage) ->
      Q.LevelParser.default_load_level(stage, level_data, num_bullets) 

    Q.stageScene "level",
      sort: true
    Q.stageScene "hud", 2,
      sort: true
    Q.stageScene "gaze_overlay", 1, 
      sort: true

    # the story
    Game.infoLabel.intro()

    # for analytics
    Game.currentScreen = "level" + number

  stageLevelSelectScreen: ->
    @Q.input.disableTouchControls()

    # reset current level state
    @Q.state.set "currentLevel", 0

    @Q.clearStages()
    @Q.stageScene "levelSelect"

    console.log(Q.width)
    console.log(Q.height)

    # for analytics
    Game.currentScreen = "levelSelect"

  stageEndLevelScreen: ->
    @Q.input.disableTouchControls()

    @Q.clearStages()
    @Q.stageScene "levelSummary", Game.currentLevelData

    # for analytics
    Game.currentScreen = "levelSummary for level" + @Q.state.get("currentLevel")

  stageEndScreen: ->
    @Q.input.disableTouchControls()
    @Q.clearStages()
    @Q.stageScene "end"

    # for analytics
    Game.currentScreen = "end"

    # track events
    Game.trackEvent("End Screen", "displayed")

  stageScreen: (screen_name) ->
    @Q.clearStages()
    @Q.stageScene screen_name

    # for analytics
    Game.currentScreen = screen_name

  stageMoreLevels: (page) ->
    max_pages = Math.ceil(Game.levels_array.length - 6)/4 
    if page >= 0 and page <= max_pages
      screen_name = "levelSelectMore"

      Game.moreLevelsPage = page

      @Q.clearStages()
      @Q.stageScene screen_name

      # for analytics
      Game.currentScreen = screen_name     

  stageTutorial: ->
    Q = @Q

    Q.state.reset
      enemiesCounter: 0
      lives: 5
      bullets: 0
      hasKey: false
      hasGun: false
      currentLevel: 0 # for saving the progress
      canEnterDoor: false

    Game.currentLevelData = # for level summary
      zombies:
        healed: 0
        available: 0
      health:
        collected: 0
        available: 0
      bullets:
        waisted: 0
        available: 0
      zombieModeFound: false

    Q.input.touchControls() # render onscreen touch buttons

    Q.clearStages()
    Q.stageScene "tutorial",
      sort: true
    Q.stageScene "hud", 2,
      sort: true
    Q.stageScene "gaze_overlay", 1,
      sort: true

    # the story
    Game.infoLabel.tutorial()

    # for analytics
    Game.currentScreen = "tutorial"


  stageGameOverScreen: ->
    @Q.clearStages()
    @Q.stageScene "gameOver"

    # for analytics
    Game.currentScreen = "gameOver"

    # track events
    Game.trackEvent("Game Over Screen", "displayed")

  setCameraTo: (stage, toFollowObj) ->
    stage.follow toFollowObj,
      x: true
      y: true
    ,
      minX: 0
      maxX: Game.map.p.w
      minY: 0
      maxY: Game.map.p.h

  trackEvent: (category, action, label, value) ->
    if false # we've turned off google analytics for now
      if !label?
        ga 'send', 'event', category, action
      else if !value?
        ga 'send', 'event', category, action, label.toString()
        # console.log('_gaq.push', category + ' | ', action + ' | ', label.toString())
      else
        ga 'send', 'event', category, action, label.toString(), parseInt(value, 10)
        # console.log('_gaq.push', category + ' | ', action + ' | ', label.toString() + ' | ', parseInt(value, 10))

  initUnloadEvent: ->
    window.addEventListener "beforeunload", (e) ->
      Game.trackEvent("Unload", "Current Screen", Game.currentScreen)


  add_door_button: (stage, doorPos) -> 
    Q = @Q
    stage.insert new Q.UI.DoorButton
      x: doorPos.x
      y: doorPos.y - 2.5* Game.assets.map.tileSize 


# init game
Game.init()
