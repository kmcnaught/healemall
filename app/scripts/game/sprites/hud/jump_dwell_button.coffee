Q = Game.Q

Q.UI.JumpDwellButton = Q.UI.PolygonButton.extend "UI.JumpDwellButton",
  init: (p, defaultProps) ->
    @_super p,
      type: Q.SPRITE_UI | Q.SPRITE_DEFAULT
      fill: "#c4da4a50"
      radius: 10
      fontColor: "#353b47"
      font: "400 58px Jolly Lodger"
      faces_left: true      

    @doDwell = true

    if @p.h is undefined
      throw "cannot create jump arrow without height defined"
    if @p.w is undefined
      throw "cannot create jump arrow without width defined"

    @p.points = @get_interact_points()
    @p.polygon = @get_render_points()

    # Set up dwell/touch response
    if @p.dwell_action
      @on "click", (e) -> 
        Q.inputs[@p.dwell_action]=1
        Q.input.trigger(@p.dwell_action);

  get_render_points: () ->
    # shapes figured out in inkscape and hardcoded     
    leftjump_normalised = [
            [0.5, 0.5],
            [0.5, 0.15],
            [0.428571428571429, -0.0714285714285714],
            [0.214285714285714, -0.321428571428571],
            [0.428571428571429, -0.5],
            [-0.5, -0.5],
            [-0.5, 0.321428571428571],
            [-0.321428571428571, 0.142857142857143],
            [-0.214285714285714, 0.25],
            [-0.214285714285714, 0.5],
          ]   
    rightjump_normalised = [
            [-0.5, 0.5],
            [-0.5, 0.15],
            [-0.428571428571429, -0.0714285714285714],
            [-0.214285714285714, -0.321428571428571],
            [-0.428571428571429, -0.5],
            [0.5, -0.5],
            [0.5, 0.321428571428571],
            [0.321428571428571, 0.142857142857143],
            [0.214285714285714, 0.25],
            [0.214285714285714, 0.5],
          ]

    if @p.faces_left
      points = leftjump_normalised
    else
      points = rightjump_normalised

    # scale up
    h = @p.h
    w = @p.w
    points = ([p[0]*w*.9, p[1]*h*.9] for p in points)

    return points

  get_interact_points: () ->    
    return @get_render_points()