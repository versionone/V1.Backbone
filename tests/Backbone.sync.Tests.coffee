V1 = require('../V1.Backbone')

JsonQuery = V1.JsonQuery

expect = require('chai').expect
Backbone = require('backbone')
recorded = require('./recorded')

deferred = require('Deferred')


describe "Using sync to fetch a collection", ->

  beforeEach ->
    V1.Backbone.setDefaultInstance(url: "url", fetch: recorded)

  afterEach ->
    V1.Backbone.clearDefaultInstance()

  it "can populate a model with  basic schema", ->
    Members = V1.Backbone.Collection.extend
      model: V1.Backbone.Model.extend
        assetType: "Member"
        schema: [ "Name" ]

    members = new Members()
    members.fetch()
    expect(members.length).to.equal(5)
    expectedNames = ["Administrator","Bob McBobertan","Ian B","Ian Culling","Matt Higgins"]
    expect(members.pluck("Name")).to.deep.equal(expectedNames)


describe "Using sync to fetch a model", ->

  beforeEach ->
    V1.Backbone.setDefaultInstance(url: "url", fetch: recorded)

  it "can sync an indiviual model", ->
    Member = V1.Backbone.Model.extend
        assetType: "Member"
        schema: [ "Name" ]

    admin = new Member(_oid: "Member:1017")
    admin.fetch()

    expect(admin.get("Name")).to.equal("Bob McBobertan")



