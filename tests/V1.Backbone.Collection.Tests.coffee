V1 = require('../V1.Backbone')
expect = require('chai').expect
recorded = require('./recorded')
deferred = require('Deferred')
spy = require('sinon').spy

makeFetcher = (queryChecker) ->
  spy (actualUrl, query) ->
    queryChecker(query) if queryChecker?
    deferred()

describe "A V1.Backbone.Collection", ->
  describe "filtering a collection", ->

    afterEach ->
      V1.Backbone.clearDefaultRetriever()

    it "should generate a correct query", ->
      fetch = makeFetcher (query) ->
        expect(query).to.equal('{"from":"Member","select":["Name"],"filter":["ParticipatesIn[AssetState!=\'Dead\'].Participants=\'Member:20\'"]}')

      V1.Backbone.setDefaultRetriever(url: "url", fetch: fetch)

      Member = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: ["Name"]

      Teammates = V1.Backbone.Collection.extend
        model: Member
        queryOptions:
          filter: ["ParticipatesIn[AssetState!='Dead'].Participants='Member:20'"]

      mates = new Teammates()
      mates.fetch()

  describe "finding for a collection", ->
    afterEach ->
      V1.Backbone.clearDefaultRetriever()

    it "should generate a correct query", ->
      fetch = makeFetcher (query) ->
        expect(query).to.equal('{"from":"Member","select":["Name"],"findIn":["Name","Nickname","Email"],"find":"Andre"}')

      V1.Backbone.setDefaultRetriever(url: "url", fetch: fetch)

      Member = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: ["Name"]

      MemberSearch = V1.Backbone.Collection.extend
        model: Member
        queryOptions:
          findIn: ["Name", "Nickname", "Email"]

      search = new MemberSearch()
      search.fetch({"find":"Andre"})