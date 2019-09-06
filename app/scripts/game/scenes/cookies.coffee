Q = Game.Q

Q.scene "cookies", (stage) ->

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2

  titleContainer.insert new Q.UI.Container
    x: 0,
    y: 0,
    w: Q.width,
    h: Q.height
    z: 50
    fill: "rgba(0,0,0,0.5)"

  titleContainer.insert new Q.UI.Text
    x: 0,
    y: -Q.height/4,
    label: "Cookies"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: Styles.fontsize11

  description = "This site uses cookies and local data storage\n"
  description += "to save your game progress and preferences\n"
  description += "and to enable narration services."

  desc = titleContainer.insert new Q.UI.Text
      x: 0,
      y: 0,
      align: 'center'
      label: description
      color: "#9ca2ae"
      family: "Jolly Lodger"
      size: Styles.fontsize5
  
  label = "Accept"

  button = titleContainer.insert new Q.UI.Button
    x: 0,
    y: Q.height/4,
    w: Q.width/3
    h: 80
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  button.on "click", (e) ->    
    Game.settings.cookiesAccepted.set("true")    
    Game.stageScreen("start")
    
  titleContainer.fit()

  
