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
    testRelation = relation("test").as(model)
    expect(testRelation.type).to.equal(model)
    expect(testRelation.isSingle()).to.be.true
    expect(testRelation.isMulti()).to.be.false

  it "should not be able to set it something crazy", ->
    model = ->
    expect( -> relation("test").as(model) ).to.throw(/unsupported/i)


