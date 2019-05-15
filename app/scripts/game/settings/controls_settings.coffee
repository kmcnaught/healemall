Q = Game.Q

Q.scene "controls_settings", (stage) ->

  # audio
  Q.AudioManager.stopAll()
  Q.AudioManager.clear()

  # add title
  y_pad = Q.height/20

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2

  description = "More settings coming soon...\n"
  description += "including difficulty, narration, and in-game UI size..."
  
  title = titleContainer.insert new Q.UI.Text
    x: 0
    y: -Q.height*0.35
    label: "Settings"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 90

  title.size()

  # button
  label = "Back"
  buttonTextSize = Q.ctx.measureText(label)
  button = titleContainer.insert new Q.UI.Button
    x: 0
    y: Q.height*0.35
    w: buttonTextSize.width*1.3
    h: 80
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  desc = titleContainer.insert new Q.UI.Text
      x: 0
      y: Q.height*0.15
      align: 'center'
      label: description
      color: "#000000"
      family: "Jolly Lodger"
      size: 36

  # panel
  titleContainer.insert new Q.UI.Container
    x: desc.p.x
    y: desc.p.y
    w: desc.p.w*1.1
    h: desc.p.h*1.1
    z: desc.p.z - 1
    fill: "#e3ecf933",
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  titleContainer.fit()

  # authors
  authors = stage.insert new Q.UI.Authors()

  button.on "click", (e) ->
    Game.stageLevelSelectScreen()

  # TODO: actually, maybe have all adjuster stuff as callback, rather than hacking into preferences struct
  
  dwell_getter = () ->
    dTimeMs = localStorage.getItem(Game.storageKeys.dwellTime) || 1000
    return dTimeMs/1000

  dwell_setter = (val) ->
    console.log('new dwell time! ' + val)
    val = val*1000
    Game.setupGaze(val)
    localStorage.setItem(Game.storageKeys.dwellTime, val)

  Q.Adjuster.add(stage, Q.width/2, Q.height*0.4, 400, 200,'Dwell time (s)', dwell_getter, dwell_setter)
