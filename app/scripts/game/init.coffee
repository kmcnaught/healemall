
class StorageItem
  # Something store-able in local storage, with a default
  constructor: (key, default_val) ->
    @key = @getKey(key)
    @default_val = default_val
    @is_boolean = (typeof default_val == "boolean")  

  getKey: (key) ->
    return "zombieGame:" + key

  get: () ->
    if @is_boolean
      return @boolValueOrDefault(@key, @default_val)
    else
      return localStorage.getItem(@key) || @default_val

  set: (s) ->    
    localStorage.setItem(@key, s)     

  boolValueOrDefault: (key, defaultVal) ->
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


class Achievements
  # Progress in game, saved in local storage
  # Also encapsulates any composite achievements, like getting full marks.

  constructor: (total_levels) ->
    @availableLevel = new StorageItem("availableLevel", 1)        
    @total_levels = total_levels

    # progress is stored individually per-level
    @progressKey = "levelProgress"
    
    @progress = []
    for level in [0..total_levels]  
      @progress.push new StorageItem(@progressKey + ":" + level, 0)

  getProgressForLevel: (level) ->
    return @progress[level].get()

  hasCompletedMainLevels: ->      
    for level in [1..5]
      prog = @progress[level]
      if prog == 0
        return false      
    return true

  hasCompletedMainLevelsFullStars: ->      
    for level in [1..5]
      prog = @progress[level]
      if prog < 3
        return false
    return true

  hasCompletedAllLevels: ->      
    for level in [1..@total_levels]      
      prog = @progress[level]
      if prog == 0
        return false
    return true

  hasCompletedAllLevelsFullStars: ->      
    for level in [1..@total_levels]      
      prog = @progress[level]
      if prog < 3
        return false
    return true 


class Settings
  
  constructor: () ->
    @cookiesAccepted = new StorageItem("cookiesAccepted", false)
    @showCursor = new StorageItem("showCursor", true)
    @dwellTime = new StorageItem("dwellTime", 1000)
    @narrationEnabled = new StorageItem("narrationEnabled", false)
    @useBuiltinDwell = new StorageItem("useBuiltinDwell", true)
    @useKeyboardInstead = new StorageItem("useKeyboardInstead", false)
    @useOwnClickInstead = new StorageItem("useOwnClickInstead", false)
    @uiScale =  new StorageItem("uiScale", 1.0)
    @uiOpacity = new StorageItem("uiOpacity", 0.25)
    @musicEnabled = new StorageItem("disableMusic", true)
    @soundFxEnabled = new StorageItem("disableSoundFx", true)
    @lives = new StorageItem("lives", 3)
    @zombieSpeed = new StorageItem("zombieSpeed", 1.0)
    @zombiesChase = new StorageItem("zombiesChase", true)
    @unlimitedAmmo = new StorageItem("unlimitedAmmo", false)
    @startWithGun = new StorageItem("startWithGun", false)

# main game object
window.Game =
  init: ->
    # engine instance
    @Q = Q = Quintus
      development: true
      audioSupported: [ 'ogg', 'mp3' ]

    Game.settings = new Settings()
    Game.achievements = new Achievements()

    # Quintus setup
    Q.include "Sprites, Scenes, Input, Touch, Gaze, UI, 2D, Anim, Audio"
    Q.setup
      # width: 640
      # height: 320
      width:   800 #// Set the default width to 800 pixels
      height:  600 #// Set the default height to 600 pixels
      scaleToFit: true #// Scale the game to fit the screen of the player's device
      maximize: true
      # upsampleWidth: 640
      # upsampleHeight: 320
      # downsampleWidth: 1024, # Halve the pixel density if resolution
      # downsampleHeight: 768  # is larger than or equal to 1024x768
    Q.controls().touch(Q.SPRITE_UI, [0,1,2,10])

    Q.enableSound()

    # Extra keybindings not in quintus defaults
    Q.input.bindKey(67, "cursor")    
    
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

    # Set up some things from settings
    @setupGaze(Game.settings.dwellTime.get())
    @setCursorState(Game.settings.showCursor.get(), false) # don't save since we might not have cookie acceptance yet
    Q.input.on("cursor", @, "toggleCursor")  

    return

  setupGaze: (dwell_time) ->
    @Q.controls().untrackGaze()
    @Q.controls().trackGaze(@Q.SPRITE_UI, [0,1,2,10], dwell_time)

  turnOffGaze: () ->
    @Q.controls().untrackGaze()

  setCursorState: (cursor_on, save_state=true) ->
    console.log("Setting cursor state: " + cursor_on)
    # Update game state
    @Q.state.set "showCursor", cursor_on
    
    # Persist in local storage
    if save_state
      Game.settings.showCursor.set(cursor_on)

    # Change styling to hide/show cursor
    element = document.getElementById("quintus_container")
  
    if cursor_on
      element.style.cursor = "auto"     
    else
      element.style.cursor = "none"     

  toggleCursor: ->
    @setCursorState(!Q.state.get("showCursor"))

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
        bullets: 6
      level5:
        dataAsset: "level5.tmx"
        bullets: 15
      level6:
        dataAsset: "steps.tmx"
        bullets: 10
        name: "Steps"
      level7:
        dataAsset: "hurdles.tmx"
        bullets: 10
        name: "Hurdles"
      level8:      
        dataAsset: "pyramid.tmx"
        bullets: 10
        name:"Pyramid"  
      level9:
        dataAsset: "diamond.tmx"
        bullets: 20
        name: "Diamond"        
      level10:
        dataAsset: "trickyJumps.tmx"
        bullets: 10
        name: "Tricky Jumps"
      level11:
        dataAsset: "tooManyZombies.tmx"
        bullets: 20
        name: "Too Many Zombies"
      level12:
        dataAsset: "trickyJumpsMore.tmx"
        bullets: 20
        name: "More Tricky Jumps"      
        

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
      
    Game.achievements = new Achievements(Game.levels_array.length - 1)

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

    start_bullets = if Game.settings.startWithGun.get() then 10 else 0

    Q.state.set
      enemiesCounter: 0
      lives: Number.parseInt(Game.settings.lives.get())
      bullets: start_bullets
      hasKey: false
      hasGun: Game.settings.startWithGun.get()
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

    # Q.input.touchControls() # render onscreen touch buttons

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

    if not Game.settings.useKeyboardInstead.get()
      Q.stageScene "gaze_overlay", 1, 
        sort: true

    # the story
    Game.infoLabel.intro()

    # for analytics
    Game.currentScreen = "level" + number
    @Q.state.set "currentLevel", number

    # unlock the next level
    # We only save progress up to Level 5; bonus levels are always available
    if number <= 5 and number >= Game.achievements.availableLevel.get()      
      Game.achievements.availableLevel.set(number + 1)


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

    Q.state.set
      enemiesCounter: 0
      lives: 15
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

    # Q.input.touchControls() # render onscreen touch buttons

    Q.clearStages()
    Q.stageScene "tutorial",
      sort: true
    Q.stageScene "hud", 2,
      sort: true

    # info speaking interferes with (more important) narration of tutorial instrucitons
    if Game.settings.narrate.get()
      Game.infoLabel.disable()
    
    if not Game.settings.useKeyboardInstead.get()
      Q.stageScene "gaze_overlay", 1,
        sort: true

    # the story
    Game.infoLabel.tutorial()

    # for analytics
    Game.currentScreen = "tutorial"
    @Q.state.set "currentLevel", 0


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
