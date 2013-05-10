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

  describe "with filters", ->

    it "should be filterable", ->
      testRelation = relation("Test")
        .of(V1.Backbone.Collection)
        .filter("FilterToken='1'")

      expect(testRelation.filters).to.deep.equal(["FilterToken='1'"])

    it "should be filterable to multiple filters", ->
      testRelation = relation("Test")
        .of(V1.Backbone.Collection)
        .filter("FilterToken='1'", "ID=Test:1001")

      expect(testRelation.filters).to.deep.equal(["FilterToken='1'", "ID=Test:1001"])

    it "new filters should *ADD TO* existing ones", ->
      testRelation = relation("Test")
        .of(V1.Backbone.Collection)
        .filter("FilterToken='1'", "ID=Test:1001")

      hijackedRelation = testRelation.filter("FilterToken2")

      expect(hijackedRelation.filters).to.deep.equal(["FilterToken='1'", "ID=Test:1001", "FilterToken2"])
      expect(testRelation.filters).to.deep.equal(["FilterToken='1'", "ID=Test:1001"])

  describe "with wheres", ->

    it "should be where-able", ->
      testRelation = relation("Test")
        .of(V1.Backbone.Collection)
        .where("FilterToken":'1')

      expect(testRelation.wheres).to.deep.equal({"FilterToken":'1'})

    it "should accept multiple wheres", ->
      testRelation = relation("Test")
        .of(V1.Backbone.Collection)
        .where("FilterToken":'1', "ID":"Test:1001")

      expect(testRelation.wheres).to.deep.equal({"FilterToken":'1', "ID":"Test:1001"})

    it "new wheres should *ADD TO* existing ones", ->
      testRelation = relation("Test")
        .of(V1.Backbone.Collection)
        .where("FilterToken":'1', "ID":"Test:1001")

      hijackedRelation = testRelation.where("FilterToken2":"100")

      expect(hijackedRelation.wheres).to.deep.equal({"FilterToken":'1', "ID":"Test:1001", "FilterToken2":"100"})