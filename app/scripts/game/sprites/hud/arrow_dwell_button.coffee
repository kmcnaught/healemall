Q = Game.Q

Q.UI.ArrowDwellButton = Q.UI.PolygonButton.extend "UI.ArrowDwellButton",
  init: (p, defaultProps) ->
    @_super p,
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      fill: "#c4da4a50"
      radius: 10
      fontColor: "#353b47"
      font: "400 58px Jolly Lodger"
      faces_left: true      

    @doDwell = false

    if @p.h is undefined
      throw "cannot create arrow without height defined"
    if @p.w is undefined
      throw "cannot create arrow without width defined"

    @p.points = @get_interact_points()
    @p.polygon = @get_render_points()

    # Set up dwell/touch response
    if @p.hover_action
      @on "hover", (e) => 
        Q.inputs[@p.hover_action]=1

      @on "touch", (e) => 
        Q.inputs[@p.hover_action]=1

      @on "touchEnd", (e) => 
        Q.inputs[@p.hover_action]=0


  get_render_points: () ->
    # define some shapes for the main gaze controls  
    stem_h = @p.h*.275 # varies height of arrow stem (from centre)
    stem_w = @p.w*.05 # varies length of arrow stem (from centre)
    stem_start = @p.w*0.4 # varies how much stem is shrunk to balance the visual weight
    h = @p.h
    w = @p.w

    if @p.faces_left
      points = [
            [stem_start, -stem_h],
            [-stem_w, -stem_h],
            [-stem_w, -h/2],
            [-w/2, 0],
            [-stem_w, h/2],
            [-stem_w, stem_h],
            [stem_start, stem_h],
          ]   
    else
      points = [
            [-stem_start, stem_h],
            [stem_w, stem_h],
            [stem_w, h/2],
            [+w/2, 0],
            [stem_w, -h/2],
            [stem_w, -stem_h],
            [-stem_start, -stem_h],
          ]

    points = ([p[0]*1.2, p[1]*1.2] for p in points)

    return points

  # Quintus uses convex hull of 'points' property to capture mouse events
  # so if we have a concave shape, we need different 'points' to define
  # interactable part (not necessarily whole polygon drawn)
  # For the arrow, we ignore the tips of the arrow head that extend beyond the stem height
  get_interact_points: () ->
    stem_h = @p.h*.275 # varies height of arrow stem (from centre)
    stem_w = @p.w*.05 # varies length of arrow stem (from centre)
    stem_start = @p.w*0.4 # varies how much stem is shrunk to balance the visual weight
    h = @p.h
    w = @p.w

    if @p.faces_left
      intersection_x = w/2 - (stem_h/h)*(w - 2*stem_w) # intersection of stem and arrow
      points = [
            [stem_start, -stem_h],
            [-stem_w, -stem_h],
            [-intersection_x, -stem_h],
            [-w/2, 0],
            [-intersection_x, stem_h],
            [-stem_w, stem_h],
            [stem_start, stem_h],
          ]   
    else
      intersection_x = w/2 - (stem_h/h)*(w - 2*stem_w) # intersection of stem and arrow
      points = [
            [-stem_start, stem_h],
            [stem_w, stem_h],
            [intersection_x, stem_h],
            [+w/2, 0],
            [intersection_x, -stem_h],
            [stem_w, -stem_h],
            [-stem_start, -stem_h],
          ]

    points = ([p[0]*1.2, p[1]*1.2] for p in points)

    return points