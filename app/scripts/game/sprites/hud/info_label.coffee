Q = Game.Q

Q.UI.InfoLabel = Q.UI.Text.extend "UI.InfoLabel",
  init: (p, defaultProps) ->
    @_super p,
      x: 0
      y: 0
      label: ""
      color: "#222221"
      size: 24
      family: "Boogaloo"
      pendingLabel: ""
      disabled: false

  disable: () ->
    @p.disabled = true

  enable: () ->
    @p.disabled = false

  speak:  (phrase) ->
    if Game.settings.narrationEnabled.get()
      responsiveVoice.speak(phrase);

  changeLabel: (new_label) ->    
    if not @p.disabled
      if new_label is this.pendingLabel
        return
      this.pendingLabel = new_label
      @afterLabelChange "..."
      self = this;
      setTimeout ( -> 
        self.afterLabelChange new_label
        self.speak new_label ), 250

  afterLabelChange: (new_label) ->
    if new_label
      @p.label = new_label 
    
    @calcSize()
    @p.container.p.x = @p.offsetLeft + @p.w/2 + 10
    @p.container.fit(5, 10)
    Q._generatePoints(@)

  tutorial: ->
    @changeLabel "If you can complete this tutorial you're ready to save some zombies"

  intro: ->
    @changeLabel "I need to find the way out of here"

  keyNeeded: ->
    @changeLabel "I need the key"

  doorOpen: ->
    @changeLabel "Nice! Now I need to enter the door"

  gunFound: ->
    @changeLabel "I found the gun, I can shoot zombies"

  moreBullets: ->
    @p.label = "I found more bullets!"
    @afterLabelChange()

  outOfBullets: ->
    @changeLabel "I'm out of ammo"

  keyFound: ->
    @changeLabel "I found the key, now I need to find the door"

  clear: ->
    @afterLabelChange ""

  lifeLevelLow: ->
    @changeLabel "No more spare lives! I need to be more careful"

  extraLifeFound: ->
    @changeLabel "I feel better now!"

  lifeLostZombie: ->
    random = Math.floor(Math.random() * 3)
    if random == 0
      label = "Ouch!"
    else if random == 1
      label = "I've been bitten!"
    else 
      label = "That hurts!"
      
    @changeLabel label

  lifeLostFall: ->
    random = Math.floor(Math.random() * 3)
    if random == 0
      label = "Ouch!"
    else if random == 1
      label = "Oops!"
    else 
      label = "That hurt!"
      
    @changeLabel label

  zombieModeOn: ->
    @changeLabel "I was bitten too many times. "

  zombieModeOnNext: ->
    @changeLabel "I've turned into a zombie. Nooo!"

  zombieModeOff: ->
    @changeLabel "Ok, back to business"


