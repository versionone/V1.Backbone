Backbone = require('backbone')
V1 = require('../V1.Backbone')
expect = require('chai').expect
recorded = require('./recorded')
deferred = require('JQDeferred')

describe "Fetching with `sync`", ->

  describe "a collection", ->

    Members = V1.Backbone.Collection.extend
      model: V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: [ "Name" ]

    beforeEach ->
      V1.Backbone.setDefaultRetriever(url: "url", fetch: recorded)

    afterEach ->
      V1.Backbone.clearDefaultRetriever()

    it "can find all members", ->
      members = new Members()
      members.fetch()

      expectedNames = ["Administrator","Bob McBobertan","Ian B","Ian Culling","Matt Higgins"]
      expect(members.pluck("Name")).to.deep.equal(expectedNames)

    it "can find talkative members, using filters", ->
      members = new Members()
      members.fetch(filter: ["ParticipatesInConversations.@Count>'4'"])

      expectedNames = ["Administrator","Matt Higgins"]
      expect(members.pluck("Name")).to.deep.equal(expectedNames)

    it "find members who belong to two scopes, using wheres", ->
      members = new Members()
      members.fetch(where: {"Scopes.@Count": 2 } )

      expectedNames = ["Administrator"]
      expect(members.pluck("Name")).to.deep.equal(expectedNames)

  describe "a collection with a mixin", ->

    Member = Backbone.Model.extend
      queryOptions:
        assetType: "Member"
        schema: [ "Name" ]

    Members = Backbone.Collection.extend
      model: Member

    V1.Backbone.mixInTo(Member)
    V1.Backbone.mixInTo(Members)



    beforeEach ->
      V1.Backbone.setDefaultRetriever(url: "url", fetch: recorded)

    afterEach ->
      V1.Backbone.clearDefaultRetriever()

    it "can find all members", ->
      members = new Members()
      members.fetch()

      expectedNames = ["Administrator","Bob McBobertan","Ian B","Ian Culling","Matt Higgins"]
      expect(members.pluck("Name")).to.deep.equal(expectedNames)

    it "can find talkative members, using filters", ->
      members = new Members()
      members.fetch(filter: ["ParticipatesInConversations.@Count>'4'"])

      expectedNames = ["Administrator","Matt Higgins"]
      expect(members.pluck("Name")).to.deep.equal(expectedNames)

    it "find members who belong to two scopes, using wheres", ->
      members = new Members()
      members.fetch(where: {"Scopes.@Count": 2 } )

      expectedNames = ["Administrator"]
      expect(members.pluck("Name")).to.deep.equal(expectedNames)

  describe "a collection, with relations", ->

    Expressions = V1.Backbone.Collection.extend
      model: V1.Backbone.Model.extend
        queryOptions:
          assetType: "Expression"
          schema: "Content"

    Members = V1.Backbone.Collection.extend
      model: V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: [
            "Name"
            V1.Backbone.alias("ParticipatesInConversations.@Count").as("ParticipationCount")
            V1.Backbone.relation("ParticipatesInConversations").of(Expressions)
          ]

    beforeEach ->
      V1.Backbone.setDefaultRetriever(url: "url", fetch: recorded)

    afterEach ->
      V1.Backbone.clearDefaultRetriever()

    it "will get members and the expressions they participate in", ->
      members = new Members()
      members.fetch()

      members.each (member) ->
        expect(member.get("ParticipatesInConversations").length).to.equal(parseInt(member.get("ParticipationCount"),10))


  describe "a model", ->

    beforeEach ->
      V1.Backbone.setDefaultRetriever(url: "url", fetch: recorded)

    afterEach ->
      V1.Backbone.clearDefaultRetriever()

    it "can sync an indiviual model", ->
      Member = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: [ "Name" ]

      admin = new Member(_oid: "Member:1017")
      admin.fetch()

      expect(admin.get("Name")).to.equal("Bob McBobertan")



