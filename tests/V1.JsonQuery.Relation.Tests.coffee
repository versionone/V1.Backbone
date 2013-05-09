V1 = require('../Backbone.V1')
relation = V1.JsonQuery.relation
expect = require('chai').expect

describe "An attribute alias", ->

  it "should hold on to the attribute", ->
    expect(relation("test").attribute).to.equal("test")

  it "the type should be a generic `V1.Collection` by default", ->
    testRelation = relation("test")
    expect(testRelation.type).to.equal(V1.Collection)
    expect(testRelation.isSingle()).to.be.false
    expect(testRelation.isMulti()).to.be.true

  it "should be able to change the alias name", ->
    model = V1.Model.extend()
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


