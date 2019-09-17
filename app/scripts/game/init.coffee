
# Validation methods for settings
validate_bool = (val) ->
  
  if (typeof(val) == "string")
    val = val.toLowerCase()
    if (val == false.toString())
      return false
    else if (val == true.toString())
      return true
    else
      num = Number(val)
      if num == 0
        return false
      else if num == 1
        return true
      else
        console.log('Cannot parse string "' + val + '"as boolean')
        #throw 'Cannot parse string "' + val + '"as boolean'
  else 
    return Boolean(val)


validate_num_lims = (val, minVal=null, maxVal=null) ->
  num = Number(val)
  if isNaN(num)
    console.log('Cannot parse "' + val + '"as number')
    #throw 'Cannot parse "' + val + '"as number'
  else
    if minVal?
      num = Math.max(minVal, num)
    if maxVal?
      num = Math.min(maxVal, num)
    return num


validate_num = (val) ->
  return validate_num_lims(val, null, null)

validate_noop = (val) ->
  return val


class StorageItem
  # Something store-able in local storage, with a default
  constructor: (key, default_val, validator) ->
    @key = @getKey(key)
    @default_val = default_val
    @staged_val = undefined # stage changes if not able to commit (need user permission)
    @is_boolean = (typeof default_val == "boolean")  
    @validator = validator

  getKey: (key) ->
    return "zombieGame:" + key

  get: () ->
    if @is_boolean
      return @boolValueOrDefault(@key, @default_val)
    else
      return @staged_val || localStorage.getItem(@key) || @default_val

  isSaved: () ->
    return !(localStorage.getItem(@key) is null)

  setDefault: (default_val) ->
    default_val_v = @validator(default_val)
    if default_val_v?
      # Set a new default - this *won't* override a user-saved setting
      @default_val = default_val_v
    else
      console.log("Error setting default val: #{default_val}")

  set: (s, force_save=false) ->    
    s_v = @validator(s)
    if s_v? and (force_save or @get() != s_v)
        localStorage.setItem(@key, s_v)     

  set_staged: (s) ->
    s_v = @validator(s)
    if s_v?
      @staged_val = s_v

  reset: () ->
    localStorage.removeItem(@key)

  commit_staged_change: () ->
    if @staged_val? 
      @set(@staged_val, true)

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
    @availableLevel = new StorageItem("availableLevel", 1, validate_num)       
    @total_levels = total_levels

    # progress is stored individually per-level
    @progressKey = "levelProgress"
    
    @progress = []
    for level in [0..total_levels]  
      @progress.push new StorageItem(@progressKey + ":" + level, 0, validate_num)

    # record when we've congratulated the user
    @congratulatedMainLevels = new StorageItem("congratulatedMainLevels", false, validate_num)
    @congratulatedMainLevelsFullStars = new StorageItem("congratulatedMainLevelsFullStars", false, validate_num)
    @congratulatedAllLevels = new StorageItem("congratulatedAllLevels", false, validate_num)
    @congratulatedAllLevelsFullStars = new StorageItem("congratulatedAllLevelsFullStars", false, validate_num)

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
    @cookiesAccepted = new StorageItem("cookiesAccepted", false, validate_bool)
    @showCursor = new StorageItem("showCursor", true, validate_bool)
    @dwellTime = new StorageItem("dwellTime", 1000, (val) -> validate_num_lims(val, minVal=0.1))
    @narrationEnabled = new StorageItem("narrationEnabled", false, validate_bool)
    @useBuiltinDwell = new StorageItem("useBuiltinDwell", true, validate_bool)
    @useKeyboardInstead = new StorageItem("useKeyboardInstead", false, validate_bool)
    @useOwnClickInstead = new StorageItem("useOwnClickInstead", false, validate_bool)
    @uiScale =  new StorageItem("uiScale", 1.0, (val) -> validate_num_lims(val, minVal=0.05, maxVal = 2.5))
    @uiOpacity = new StorageItem("uiOpacity", 0.25, (val) -> validate_num_lims(val, minVal=0.05, maxVal = 1.0))
    @musicEnabled = new StorageItem("enableMusic", true, validate_bool)
    @soundFxEnabled = new StorageItem("enableSoundFx", true, validate_bool)
    @lives = new StorageItem("lives", 3, (val) -> validate_num_lims(val, minVal=0))
    @zombieSpeed = new StorageItem("zombieSpeed", 1.0, (val) -> validate_num_lims(val, minVal=0.05, maxVal = 2.0))
    @zombiesChase = new StorageItem("zombiesChase", true, validate_bool)
    @unlimitedAmmo = new StorageItem("unlimitedAmmo", false, validate_bool)
    @startWithGun = new StorageItem("startWithGun", false, validate_bool)
    @narrationVoice = new StorageItem("narrationVoice", "UK English Male", validate_noop) 
    # will be randomly picked first time, saved after cookie acceptance
    @femaleDoctor = new StorageItem("femaleDoctor", (Boolean)(Math.floor(Math.random() * 2)), validate_bool) 


# Global styles
window.Styles = 
  fontsize0: 12
  # the rest are major third scale, rounded (we don't use all of them)
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
      upsampleWidth: 640
      upsampleHeight: 320
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
    setInterval(@onCursorTick, 20)

    # Game mode presets
    Game.presets = [
      {
        name: "Relaxed"
        lives: 100
        zombieSpeed: 0.5      
        zombiesChase: false
        unlimitedAmmo: true
        startWithGun: true
      },
      {
        name: "Default"
        lives: 3
        zombieSpeed: 1.0      
        zombiesChase: true
        unlimitedAmmo: false
        startWithGun: false
      },    
      {
        name: "Hardcore"
        lives: 0
        zombieSpeed: 1.0
        zombiesChase: true
        unlimitedAmmo: false
        startWithGun: false
    }
    ]

    # Any ?var=value params in the url to override settings defaults
    @processUrlParams()    

    return  

  # processBasicParam: (param, param_name) ->



  processUrlParams: () ->    

    # Get URL params, if supported by browser
    try
      searchParams = new URLSearchParams(window.location.search)
      if not searchParams?
        return
    catch 
      # will get here if URLSearchParams not supported by browser
      console.log("Error parsing search params, loading defaults instead")
      return     
      
    # Define generic process function for each parameter
    processParam = (val, key) ->
      console.log("URL Param #{key}: #{val}")
      try         
        # special case for gamemode, which preloads several settings
        if key == "gamemode"
          gamemode = val
          preset_names = Game.presets.map (p) => p.name.toLowerCase();
          if gamemode.toLowerCase() in preset_names
            preset = (p for p in Game.presets when p.name.toLowerCase() == gamemode)[0]
          
            Game.settings.lives.setDefault(preset.lives)    
            Game.settings.zombieSpeed.setDefault(preset.zombieSpeed)    
            Game.settings.zombiesChase.setDefault(preset.zombiesChase)
            Game.settings.unlimitedAmmo.setDefault(preset.unlimitedAmmo)          
            Game.settings.startWithGun.setDefault(preset.startWithGun)
          else
            console.log("Cannot parse game mode: " + value)      
        else 
          # assign value to game setting's default 
          # we'll commit when we know we have cookie acceptance
          if Game.settings[key]? and not Game.settings[key].isSaved()
            Game.settings[key].set_staged(val)
          else
            console.log("Cannot find setting: " + key)      
      catch 
        console.log("Cannot parse value in URL for " + key)  
    
    # Process URL params one by one        
    try      
      searchParams = new URLSearchParams(window.location.search)
      searchParams.forEach(processParam)      
    catch e
      # will get here if URLSearchParams not supported by browser
      console.log("Error parsing search params, loading defaults instead")

  onCookieAcceptance: () ->
    # Any setup we aren't able to do until we know cookies are accepted
    # If we want to set game settings earlier, we need to cache values in 
    # their 'default' and then commit changes now

    # Save the gender for doctor character
    # (We randomly picked its default upon initialisation)
    if not Game.settings.femaleDoctor.isSaved()    
      Game.settings.femaleDoctor.set(Game.settings.femaleDoctor.get(), true)    
    
    # Save any params staged, e.g. by URL parsing
    for param of Game.settings
      Game.settings[param].commit_staged_change()


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
      characters_f:
        dataAsset: "characters.json"
        sheet: "characters_f.png"
      characters_m:
        dataAsset: "characters.json"
        sheet: "characters_m.png"
      controls:
        dataAsset: "controls.json"
        sheet: "controls.png"
      items:
        dataAsset: "items.json"
        sheet: "items.png"
      hud_f:
        dataAsset: "hud.json"
        sheet: "hud_f.png"
      hud_m:
        dataAsset: "hud.json"
        sheet: "hud_m.png"        
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

  getUserSettings: ->
    # Get list of settings that user has saved,
    # i.e. not including functional stuff like level progress
    settings_to_ignore = ["cookiesAccepted",]
    user_settings = []
    for setting of Game.settings    
      if Game.settings[setting].isSaved() and not (setting in settings_to_ignore)
        user_settings.push setting

    return user_settings        

  resetAllSettings: ->     
    user_settings = @getUserSettings()
    for setting in user_settings
      console.log('Clearing saved setting for '+ setting)
      Game.settings[setting].reset()    

  
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
