noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai' unless chai
  MakeCircle = require '../components/MakeCircle.coffee'
else
  MakeCircle = require 'noflo-canvas/components/MakeCircle.js'


describe 'MakeCircle component (and all that inherit MakeCanvasPrimative)', ->
  c = null
  sock_center = null
  sock_radius = null
  out = null

  beforeEach ->
    c = MakeCircle.getComponent()
    sock_center = noflo.internalSocket.createSocket()
    sock_radius = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.center.attach sock_center
    c.inPorts.radius.attach sock_radius
    c.outPorts.circle.attach out

  describe 'when instantiated', ->
    it 'should have two input ports', ->
      chai.expect(c.inPorts.center).to.be.an 'object'
      chai.expect(c.inPorts.radius).to.be.an 'object'
    it 'should have one output port', ->
      chai.expect(c.outPorts.circle).to.be.an 'object'

  describe 'single output', ->
    it 'should output one circle', ->
      center =
        x: 50
        y: 50
      radius = 50
      out.once "data", (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data.type).to.equal 'circle'
        chai.expect(data.center).to.equal center
        chai.expect(data.radius).to.equal radius
      sock_center.send center
      sock_radius.send radius

  describe 'multiple output', ->
    it 'should output an array of circles', ->
      center =
        x: 50
        y: 50
      radius = [25, 50]
      out.once "data", (data) ->
        chai.expect(data).to.be.an 'array'
        chai.expect(data.length).to.equal 2
        chai.expect(data[0].type).to.equal 'circle'
        chai.expect(data[1].type).to.equal 'circle'
        chai.expect(data[0].center).to.equal center
        chai.expect(data[1].center).to.equal center
        chai.expect(data[0].radius).to.equal radius[0]
        chai.expect(data[1].radius).to.equal radius[1]
      sock_center.send center
      sock_radius.send radius
