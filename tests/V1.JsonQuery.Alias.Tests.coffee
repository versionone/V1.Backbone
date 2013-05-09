JsonQuery = require('../Backbone.V1').JsonQuery
expect = require('chai').expect

describe "An attribute alias", ->

  it "should hold on to the attribute", ->
    expect(JsonQuery.alias("test").attribute).to.equal("test")

  it "should use the same name as the alias", ->
    expect(JsonQuery.alias("test").alias).to.equal("test")

  it "should be able to change the alias name", ->
    expect(JsonQuery.alias("test").as("somethingelse").alias).to.equal("somethingelse")
