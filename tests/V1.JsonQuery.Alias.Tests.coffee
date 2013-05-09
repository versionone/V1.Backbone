alias = require('../Backbone.V1').JsonQuery.alias
expect = require('chai').expect

describe "An attribute alias", ->

  it "should hold on to the attribute", ->
    expect(alias("test").attribute).to.equal("test")

  it "should use the same name as the alias", ->
    expect(alias("test").alias).to.equal("test")

  it "should be able to change the alias name", ->
    expect(alias("test").as("somethingelse").alias).to.equal("somethingelse")
