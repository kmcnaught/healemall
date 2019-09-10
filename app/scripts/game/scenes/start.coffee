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

  desc_fontsize = Math.max(Styles.fontsize3, Q.height/20)
  desc = titleContainer.insert new Q.UI.Text
      x: 0
      y: 0
      align: 'center'
      label: description
      color: "#2d3032"
      family: "Jolly Lodger"
      size: desc_fontsize

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
    size: Styles.fontsize11

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

  # 
  gaze_message = "[This is an eye gaze accessible website, controlled using a cursor or touch]"
  msg_fontsize = Math.min(Styles.fontsize2, Q.height/30)
  title = titleContainer.insert new Q.UI.Text
    x: 0
    y: button.p.y - button.p.h
    label: gaze_message
    color: "#c4da4a"
    family: "Jolly Lodger"
    size: msg_fontsize

  title.p.y = button.p.y - button.p.h*.5 - title.p.h*0.5

  # button.p.y = button.p.y + button.p.h/2 + y_pad*2

  titleContainer.fit()

  # authors
  authors = stage.insert new Q.UI.Authors()


  button.on "click", (e) ->
    Game.stageScreen("start_settings")
