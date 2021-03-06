noflo = require 'noflo'
ColorThief = require 'color-thief'

class GetColors extends noflo.Component
  description: 'Extract the dominant colors of an image'
  icon: 'file-image-o'
  constructor: ->

    @inPorts =
      canvas: new noflo.Port 'object'
    @outPorts =
      colors: new noflo.Port 'array'
      canvas: new noflo.Port 'object'

    @inPorts.canvas.on 'begingroup', (group) =>
      @outPorts.canvas.beginGroup group
      @outPorts.colors.beginGroup group
    @inPorts.canvas.on 'endgroup', (group) =>
      @outPorts.canvas.endGroup group
      @outPorts.colors.endGroup group
    @inPorts.canvas.on 'disconnect', () =>
      @outPorts.colors.disconnect()
      @outPorts.canvas.disconnect()
    @inPorts.canvas.on 'data', (canvas) =>
      thief = new ColorThief
      context = canvas.getContext '2d'
      pixels = (context.getImageData 0, 0, canvas.width, canvas.height).data
      pixelCount = canvas.width*canvas.height
      colors = thief.getPaletteFromPixels pixels, pixelCount, 10, 10
      @outPorts.colors.send colors
      @outPorts.canvas.send canvas

exports.getComponent = -> new GetColors
