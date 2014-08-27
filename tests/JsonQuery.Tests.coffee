V1 = require('../V1.Backbone')

JsonRetriever = V1.Backbone.JsonRetriever

expect = require('chai').expect
Backbone = require('backbone')
recorded = require('./recorded')
spy = require('sinon').spy
deferred = require('JQDeferred')

describe 'V1.Backbone.JsonRetriever', ->

  describe 'creating the object', ->

    it 'throws an error when a url is not provided', ->
      createWithoutUrl = -> new JsonRetriever()
      expect(createWithoutUrl).to.throw(/url required/)

    it 'does not throw an error when a url is provided', ->
      createWithoutUrl = -> new JsonRetriever(url:"/VersionOne.Web/query.legacy.v1")
      expect(createWithoutUrl).not.to.throw(/url required/)

  describe 'executing a query', ->

    it 'should not make a request if nothing has been asked for', ->
      actualUrl = "/VersionOne.Web/query.legacy.v1"

      fetcher = spy()
      query = new JsonRetriever(url:actualUrl, fetch: fetcher)
      query.exec()

      expect(fetcher.called).to.be.false

    it 'should make a request to the correct url', ->

      collection = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Member"

      actualUrl = "/VersionOne.Web/query.legacy.v1"

      fetcher = spy (url) ->
        expect(url).to.equal(actualUrl)
        deferred()

      query = new JsonRetriever(url:actualUrl, fetch: fetcher, defer: deferred)
      query.for(collection)
      query.exec()

      expect(fetcher.called).to.be.true

  describe 'converting a backbone model to a query', ->

    expectedQuery = (expected) ->
       (url, data) ->
          expect(data).to.equal(expected)
          deferred()

    describe 'basic schema', ->

      it 'can generate very simple query', ->

        Members = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Member"
              schema: ["Name"]

        ajax = expectedQuery '{"from":"Member","select":["Name"]}'

        query = new JsonRetriever(url:"url", fetch: ajax, defer: deferred)
        query.for(Members)
        query.exec()

      it 'can query with an alias', ->
        alias = V1.Backbone.alias

        Expressions = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Expression"
              schema: [ alias("Author.Name").as("Speaker") ]

        ajax = expectedQuery '{"from":"Expression","select":["Author.Name"]}'

        query = new JsonRetriever(url:"url", fetch: ajax, defer: deferred)
        query.for(Expressions)
        query.exec()

      it 'can generate a query with multiple attributes', ->

        Expressions = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Expression"
              schema: ["Author.Name", "Content"]

        ajax = expectedQuery '{"from":"Expression","select":["Author.Name","Content"]}'

        query = new JsonRetriever(url:"url", fetch: ajax, defer: deferred)
        query.for(Expressions)
        query.exec()

      it 'can generate a query with a relation', ->

        relation = V1.Backbone.relation

        Author = V1.Backbone.Model.extend
          queryOptions:
            assetType: "Member"
            schema: ["Name"]

        Expressions = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Expression"
              schema: [ relation("Author").of(Author) ]

        ajax = expectedQuery "{\"from\":\"Expression\",\"select\":[{\"from\":\"Author as Member\",\"select\":[\"Name\"]}]}"

        query = new JsonRetriever(url:"url", fetch: ajax, defer: deferred)
        query.for(Expressions)
        query.exec()

      it 'can generate a query with a mutlirelation', ->

        relation = V1.Backbone.relation

        Replies = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Expression"
              schema: ["Content"]

        Expressions = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Expression"
              schema: [ relation("ExpressionsInConversation").of(Replies) ]

        ajax = expectedQuery "{\"from\":\"Expression\",\"select\":[{\"from\":\"ExpressionsInConversation as Expression\",\"select\":[\"Content\"]}]}"

        query = new JsonRetriever(url:"url", fetch: ajax, defer: deferred)
        query.for(Expressions)
        query.exec()

    describe "filtering relations", ->

      it 'should be able to filter relations using "filter" clauses', ->

        relation = V1.Backbone.relation

        Expressions = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Expression"

        Members = V1.Backbone.Collection.extend
          model: V1.Backbone.Model.extend
            queryOptions:
              assetType: "Member"
              schema: [
                relation("ParticipatesInConversations")
                  .of(Expressions)
                  .as("BigGroups")
                  .addFilter("ConversationParticipants.@Count>='2'")
              ]

        ajax = expectedQuery '{"from":"Member","select":[{"from":"ParticipatesInConversations as Expression","filter":["ConversationParticipants.@Count>=\'2\'"]}]}'

        query = new JsonRetriever(url:"url", fetch: ajax, defer: deferred)
        query.for(Members)
        query.exec()

  describe "getting results", ->

    it 'can get results for a simple query', ->

      Members = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Member"
            schema: ["Name"]

      query = new JsonRetriever(url:"url", fetch: recorded, defer: deferred)

      query.for(Members).done (results) ->
        expect(results.length).to.equal(5)
        expect(results.at(0).get("Name")).to.equal("Administrator")

      query.exec()

    it 'can get results with an alias', ->

      Members = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Member"
            schema: [V1.Backbone.alias("Name").as("Who")]

      query = new JsonRetriever(url:"url", fetch: recorded, defer: deferred)
      query.for(Members).done (results) ->
        expect(results.length).to.equal(5)
        expect(results.at(0).get("Who")).to.equal("Administrator")

      query.exec()

    it 'can get hydrate results for a relation', ->

      Member = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: ["Name"]

      Expressions = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Expression"
            schema: [ V1.Backbone.relation("Author").of(Member) ]

      query = new JsonRetriever(url:"url", fetch: recorded, defer: deferred)
      query.for(Expressions).done (results) ->
        expect(results.length).to.equal(41)
        expect(results.at(0).get("Author").get("Name")).to.equal("Administrator")

      query.exec()

    it 'can support deep aliasing', ->

      Member = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: [ V1.Backbone.alias("Name").as("WhoDat") ]

      Expressions = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Expression"
            schema: [ V1.Backbone.relation("Author").of(Member) ]

      query = new JsonRetriever(url:"url", fetch: recorded, defer: deferred)
      query.for(Expressions).done (results) ->
        expect(results.length).to.equal(41)
        expect(results.at(0).get("Author").get("WhoDat")).to.equal("Administrator")

      query.exec()

    it 'can support deep relations', ->

      Member = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: [ V1.Backbone.alias("Name").as("WhoDat") ]

      Reply = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Expression"
            schema: [ V1.Backbone.relation("Author").of(Member) ]


      Expressions = V1.Backbone.Collection.extend
        model: V1.Backbone.Model.extend
          queryOptions:
            assetType: "Expression"
            schema: [ V1.Backbone.relation("ExpressionsInConversation").of(Reply).as("Replies") ]

      query = new JsonRetriever(url:"url", fetch: recorded, defer: deferred)
      query.for(Expressions).done (expressions) ->
        expect(expressions.length).to.equal(41)
        expect(expressions.at(1).get("Replies")).to.be.an.instanceof(V1.Backbone.Collection)
        expect(expressions.at(1).get("Replies").at(0).get("Author").get("WhoDat")).to.equal("Administrator")

      query.exec()
