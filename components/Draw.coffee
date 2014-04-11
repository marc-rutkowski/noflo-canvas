noflo = require 'noflo'

class Draw extends noflo.Component
  description: 'Draws received drawing commands'
  icon: 'pencil-square'
  constructor: ->
    @canvas = null
    @context = null
    @commands = []
    
    @inPorts =
      tick: new noflo.Port 'number'
      canvas: new noflo.Port 'object'
      commands: new noflo.ArrayPort 'object'

    @inPorts.tick.on 'data', (tick) =>
      if @context
        @parse @commands
        return
      @sendLog
        loglevel: 'error'
        message: 'Received commands but there\'s any 2d context attached.'

    @inPorts.canvas.on 'data', (canvas) =>
      @canvas = canvas
      @context = canvas.getContext('2d')
      
    @inPorts.commands.on 'data', (commands, i) =>
      @commands[i] = commands

  parse: (commands) =>
    for command in commands
      for instr, args of command
        @[instr].apply @, [args]

  clear: (rectangle) =>
    if rectangle
      @context.clearRect.apply @context, rectangle
    else
      @context.clearRect.apply @context, [0, 0, @canvas.width, @canvas.height]

  stroke: (strokableThings) =>
    for thing, arguments of strokableThings
      @context.beginPath()
      @[thing].apply @, [arguments]
      @context.stroke()

  strokeStyle: (color) =>
    @context.strokeStyle = color

  fill: (fillableThings) =>
    for thing, arguments of fillableThings
      @context.beginPath()
      @[thing].apply @, [arguments]
      @context.fill()

  fillStyle: (color) =>
    @context.fillStyle = color

  polyline: (vectors) =>
    for vector, i in vectors
      if i == 0
        @context.moveTo.apply @context, vector
      else
        @context.lineTo.apply @context, vector
      
exports.getComponent = -> new Draw
