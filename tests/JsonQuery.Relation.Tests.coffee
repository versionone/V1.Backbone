V1 = require('../V1.Backbone')
relation = V1.Backbone.relation
expect = require('chai').expect

describe "An attribute relation", ->

  it "should hold on to the attribute", ->
    expect(relation("test").attribute).to.equal("test")

  it "the type should be a generic `V1.Collection` by default", ->
    testRelation = relation("test")
    expect(testRelation.type).to.equal(V1.Backbone.Collection)
    expect(testRelation.isSingle()).to.be.false
    expect(testRelation.isMulti()).to.be.true

  it "should be able to change the alias name", ->
    model = V1.Backbone.Model.extend()
    testRelation = relation("test").of(model)
    expect(testRelation.type).to.equal(model)
    expect(testRelation.isSingle()).to.be.true
    expect(testRelation.isMulti()).to.be.false

  it "should not be able to set it something crazy", ->
    model = ->
    expect( -> relation("test").of(model) ).to.throw(/unsupported/i)

  it "should use the same name as the alias", ->
    expect(relation("test").alias).to.equal("test")

  it "should be able to change the alias name", ->
    expect(relation("test").as("somethingelse").alias).to.equal("somethingelse")

  it "should be immutable", ->
    testReltion = relation("test")

    asAbc = testReltion.as("abc").of(V1.Backbone.Collection)
    asXyz = testReltion.as("xyz").of(V1.Backbone.Model)

    expect(testReltion.alias).to.equal("test")
    expect(asAbc.alias).to.equal("abc")
    expect(asXyz.alias).to.equal("xyz")

    expect(asAbc.type).to.equal(V1.Backbone.Collection)
    expect(asXyz.type).to.equal(V1.Backbone.Model)


