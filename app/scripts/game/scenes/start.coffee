Q = Game.Q

Q.scene "start", (stage) ->

  # add title
  y_pad = Q.height/20

  titleContainer = stage.insert new Q.UI.Container
    x: Q.width/2
    y: Q.height/2

  marginButtonsY = Q.height/8

  # panel
  panel = titleContainer.insert new Q.UI.Container
    x:0
    y:0
    w: 1
    h: 1
    fill: "#e3ecf933",
    radius: 8, 
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT

  # description = "Imagine, what if the cure exists?\n"
  description = "You have found the cure for the zombie plague!\n\n"
  description += "Explore an old, abandoned graveyard,\n"
  description += "heal as many zombies as you can,\n"
  description += "and find your way out.\n\n" 
  description += "But be careful not to become one of them!"

  desc = titleContainer.insert new Q.UI.Text
      x: 0
      y: 0
      align: 'center'
      label: description
      color: "#2d3032"
      family: "Jolly Lodger"
      size: 36

  # resize panel
  panel.p.w = desc.p.w*1.1
  panel.p.h = desc.p.h*1.1
  panel.p.x -= panel.p.w/2
  panel.p.y -= panel.p.h/2
  
  title = titleContainer.insert new Q.UI.Text
    x: 0
    y: -(Q.height/2 - marginButtonsY)
    label: "Heal'em All"
    color: "#f2da38"
    family: "Jolly Lodger"
    size: 72

  # title.p.y = title.p.y - title.p.h/2 - y_pad
  title.size()

  # button
  label = "Continue"
  buttonTextSize = Q.ctx.measureText(label)
  button = titleContainer.insert new Q.UI.Button
    x: 0
    y: (Q.height/2 - marginButtonsY)
    w: buttonTextSize.width*1.3
    h: 80
    fill: "#c4da4a"
    radius: 10
    fontColor: "#353b47"
    font: "400 58px Jolly Lodger"
    label: label
    keyActionName: "confirm"
    type: Q.SPRITE_UI | Q.SPRITE_DEFAULT


  # Cursor warning if it's been left turned off
  y_title_bottom = title.p.y + title.p.h/2
  y_desc_top = desc.p.y - desc.p.h/2
  y_cursor_warning = (y_title_bottom + y_desc_top)/2
  Q.CompositeUI.add_cursor_warning(titleContainer, 0, y_cursor_warning)


  # button.p.y = button.p.y + button.p.h/2 + y_pad*2

  titleContainer.fit()

  # authors
  authors = stage.insert new Q.UI.Authors()


  button.on "click", (e) ->
    Game.stageScreen("start_settings")
