V1 = require('../Backbone.V1')
relation = V1.JsonQuery.relation
expect = require('chai').expect

describe "An attribute alias", ->

  it "should hold on to the attribute", ->
    expect(relation("test").attribute).to.equal("test")

  it "the type should be a generic `V1.Model` by default", ->
    expect(relation("test").type).to.equal(V1.Model)

  it "should be able to change the alias name", ->
    model = V1.Model.extend()
    expect(relation("test").as(model).type).to.equal(model)
