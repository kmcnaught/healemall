Q = Game.Q

Q.scene "settingsPlaceholder", (stage) ->

  # add title
  y_pad = Q.height/20

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2


  # description = "Imagine, what if the cure exists?\n"
  description = "This will be a settings page\n"
  description += "...including...\n"
  description += "\n"
  description += "- dwell/click settings\n" 
  description += "- Sizing of game UI\n" 
  description += "- difficulty, including hard-core and god mode \n"
  description += "- more settings for music / sounds / narration\n"

  # TODO link to https://raw.githubusercontent.com/cykod/Quintus/master/MIT-LICENSE.txt
  # probably a link to github where we can more easily detail things / give links

  desc = titleContainer.insert new Q.UI.Text
      x: 0
      y: 0
      align: 'center'
      label: description
      color: "#000000"
      family: "Jolly Lodger"
      size: Styles.fontsize5

  # panel
  titleContainer.insert new Q.UI.Container
    x:0
    y:0
    w: desc.p.w*1.1
    h: desc.p.h*1.1
    z: desc.p.z - 1
    fill: "#e3ecf933",
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  title = titleContainer.insert new Q.UI.Text
    x: 0
    y: desc.p.y - desc.p.h/2
    label: "Settings"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: Styles.fontsize13

  title.p.y = title.p.y - title.p.h/2 - y_pad
  title.size()

  # button
  label = "Back"
  buttonTextSize = Q.ctx.measureText(label)
  button = titleContainer.insert new Q.UI.Button
    x: 0
    y: desc.p.y + desc.p.h/2
    w: buttonTextSize.width*1.3
    h: 80
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  button.p.y = button.p.y + button.p.h/2 + y_pad*2

  titleContainer.fit()

  # authors
  authors = stage.insert new Q.UI.Authors()


  button.on "click", (e) ->
    Game.stageLevelSelectScreen()
