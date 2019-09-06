
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

    # record when we've congratulated the user
    @congratulatedMainLevels = new StorageItem("congratulatedMainLevels", false)
    @congratulatedMainLevelsFullStars = new StorageItem("congratulatedMainLevelsFullStars", false)
    @congratulatedAllLevels = new StorageItem("congratulatedAllLevels", false)
    @congratulatedAllLevelsFullStars = new StorageItem("congratulatedAllLevelsFullStars", false)

  getProgressForLevel: (level) ->
    return @progress[level].get()

  hasCompletedMainLevels: ->      
    for level in [1..5]
      prog = @progress[level].get()
      if prog == 0
        return false      
    return true

  hasCompletedMainLevelsFullStars: ->      
    for level in [1..5]
      prog = @progress[level].get()
      if prog < 3
        return false
    return true

  hasCompletedAllLevels: ->      
    for level in [1..@total_levels]      
      prog = @progress[level].get()
      if prog == 0
        return false
    return true

  hasCompletedAllLevelsFullStars: ->      
    for level in [1..@total_levels]      
      prog = @progress[level].get()
      if prog < 3
        return false
    return true 

  evaluatePerformance: (score) ->
    stars = 0
    message = "" 

    if score <= 0.5
      stars = 1
      message = "Okay"
    else if score > 0.5 && score < 0.9
      stars = 2
      message = "Good"
    else
      stars = 3
      message = "Perfect!"

    return {"stars": stars, "message": message}

  update: (level, stars) ->
     # save if better than previous
    previousStars = @progress[level].get()
    if stars > previousStars
      @progress[level].set(stars)

  possiblyStageAchievementsScreen: ->
    ## All levels, maximum score
    if @hasCompletedAllLevelsFullStars() and not @congratulatedAllLevelsFullStars.get()
      Game.stageAchievementScreen("""
        Amazing!\n
        You have healed every single zombie in the game.\nTop score!
        """)
      @congratulatedAllLevelsFullStars.set(true)
      @congratulatedAllLevelsStars.set(true) # subset of the above
      return true
    ## All levels complete, any score
    else if @hasCompletedAllLevels() and not @congratulatedAllLevels.get()
      Game.stageAchievementScreen("""
        Hurrah!\n
        You have completed ALL the levels, including the bonus levels.\n
        Well done!
        """)
      @congratulatedAllLevelsStars.set(true) 
      return true
    # Main (5) levels, maximum score
    else if @hasCompletedMainLevelsFullStars() and not @congratulatedMainLevelsFullStars.get()
      Game.stageAchievementScreen("""
        Brilliant!\n
        You have achieved a perfect score on all the main levels. Well done!\n
        If you've enjoyed it, keep playing to \nrack up more points in the bonus levels.
        """)
      @congratulatedMainLevelsFullStars.set(true) 
      @congratulatedMainLevels.set(true) # subset of above
      return true
    # Main (5) levels complete, any score
    else if @hasCompletedMainLevels() and not @congratulatedMainLevels.get()
      Game.stageAchievementScreen( """
        Hooray!\n
        You have completed all the main levels. Well done!\n
        If you've enjoyed it, check out the bonus levels, \nor play again to try to heal every single zombie
        """)
      @congratulatedMainLevels.set(true)
      return true
    else
      return false


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
    @musicEnabled = new StorageItem("enableMusic", true)
    @soundFxEnabled = new StorageItem("enableSoundFx", true)
    @lives = new StorageItem("lives", 3)
    @zombieSpeed = new StorageItem("zombieSpeed", 1.0)
    @zombiesChase = new StorageItem("zombiesChase", true)
    @unlimitedAmmo = new StorageItem("unlimitedAmmo", false)
    @startWithGun = new StorageItem("startWithGun", false)
    @narrationVoice = new StorageItem("narrationVoice", "UK English Male")



# Global styles
window.Styles = 
  fontsize0: 12
  # the reset are major third scale, rounded (we don't use all of them)
  fontsize1: 22
  fontsize2: 25
  fontsize3: 28
  fontsize4: 31
  fontsize5: 35
  fontsize6: 40
  fontsize7: 45
  fontsize8: 50
  fontsize9: 56
  fontsize10: 64
  fontsize11: 71
  fontsize12: 80
  fontsize13: 90
  fontsize14: 100





# main game object
window.Game =
  init: ->
    # engine instance
    @Q = Q = Quintus
      development: true
      audioSupported: [ 'ogg', 'mp3' ]

    # Q.debug = true
    # Q.debugFill = true
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

    @Q.state.set "currentLevel", 0

    # helpers
    Q.tilePos = (col, row, otherParams = {}) ->
      position =
        x: col * Game.assets.map.tileSize + Game.assets.map.tileSize/2
        y: row * Game.assets.map.tileSize + Game.assets.map.tileSize/2

      Q._extend position, otherParams

    # Set up some things from settings
    if Game.settings.useOwnClickInstead.get()
      @setupGaze(0)
    else   
      @setupGaze(Game.settings.dwellTime.get())   
    
    @setCursorState(Game.settings.showCursor.get(), false) # don't save since we might not have cookie acceptance yet
    Q.input.on("cursor", @, "toggleCursor")  

    # Narration setup: 
    if not responsiveVoice?
      # Either hasn't loaded yet, or it failed to load (e.g. network issues)
      # Replace with no-op object to avoid errors elsewhere
      window.responsiveVoice = 
        setDefaultVoice: (x) -> console.log("Responsive voice currently unavailable")
        speak: (x) -> console.log("Responsive voice currently unavailable")
        voiceSupport: () -> return false
      
    # Responsive voice never loads immediately, so set it up after a delay
    updateVoice = () ->
        responsiveVoice.setDefaultVoice(Game.settings.narrationVoice.get())    
    setTimeout(updateVoice, 1000)      

    # Turn on muting when tab not active   
    document.addEventListener('visibilitychange', @onVisibilityChange, false);

    # Force mouse events even when cursor static
    setInterval(@onCursorTick, 100)

    return

  onCursorTick: () ->
    if Q.gazeInput
      Q.gazeInput.poke();

  onVisibilityChange: () ->    
    console.log(document.visibilityState)

    if (document.visibilityState == "hidden") 
      Q.AudioManager.mute();
    else 
      Q.AudioManager.unmute();

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
      preview:
        dataAsset: "preview.tmx"
      
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

  stageAchievementScreen: (msg) ->
    Q.clearStages()
    Q.stageScene "achievement_unlocked",  {"message": msg}

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

    # We'll pick screen according to current level
    curr_level = Q.state.get("currentLevel")

    # reset current level state
    @Q.state.set "currentLevel", 0

    @Q.clearStages()
    if curr_level <=5
      @Q.stageScene "levelSelect"
    else
      Game.moreLevelsPage = Math.floor((curr_level-6)/4)
      @Q.stageScene "levelSelectMore"


    # for analytics
    Game.currentScreen = "levelSelect"

  stageEndLevelScreen: ->
    @Q.input.disableTouchControls()

    @Q.clearStages()

    # Update score for any new achievements
    score = Game.currentLevelData.zombies.healed/ Game.currentLevelData.zombies.available
    performance = Game.achievements.evaluatePerformance(score)    
    Game.achievements.update(Q.state.get("currentLevel"), performance["stars"])

    new_achievement = Game.achievements.possiblyStageAchievementsScreen()

    if not new_achievement
      @Q.stageScene "levelSummary", Game.currentLevelData

    # for analytics
    Game.currentScreen = "levelSummary for level" + @Q.state.get("currentLevel")

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

  stagePreview: ->
    Q = @Q

    Q.state.set
      enemiesCounter: 0
      lives: 15
      bullets: 100
      hasKey: false
      hasGun: true
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

    Q.clearStages()
    Q.stageScene "preview",
      sort: true

    if not Game.settings.useKeyboardInstead.get()
      Q.stageScene "gaze_overlay", 1,
        sort: true

    Q.scene "preview_back_button", (stage) ->

      marginBottomButtons = Q.height * 0.1

      pauseButton = stage.insert new Q.UI.PauseButton
        x: marginBottomButtons
        y: Q.height - marginBottomButtons    
        isSmall: false

      menuButton = stage.insert new Q.UI.MenuButton
        x: Q.width - marginBottomButtons
        y: Q.height - marginBottomButtons    
        isSmall: false

      menuButton.on "click", (e) ->
        Game.stageScreen("controls_settings")

    Q.stageScene "preview_back_button", 2,
      sort: true

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
    if Game.settings.narrationEnabled.get()
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
