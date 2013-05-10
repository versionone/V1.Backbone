V1 = require('../V1.Backbone').Backbone

JsonQuery = V1.JsonQuery

expect = require('chai').expect
Backbone = require('backbone')
recorded = require('./recorded')

deferred = require('Deferred')

describe 'V1.JsonQuery', ->

  describe 'creating the object', ->

    it 'throws an error when a url is not provided', ->
      createWithoutUrl = -> new JsonQuery()
      expect(createWithoutUrl).to.throw(/url required/)

    it 'does not throw an error when a url is provided', ->
      createWithoutUrl = -> new JsonQuery(url:"/VersionOne.Web/query.legacy.v1")
      expect(createWithoutUrl).not.to.throw(/url required/)

  describe 'executing a query', ->

    it 'should make a request to the correct url', ->
      actualUrl = "/VersionOne.Web/query.legacy.v1"

      fetcher = (url) ->
        expect(url).to.equal(actualUrl)
        deferred()

      query = new JsonQuery(url:actualUrl, fetch: fetcher)
      query.exec()

  describe 'converting a backbone model to a query', ->

    expectedQuery = (expected) ->
       (url, data) ->
          expect(data).to.equal(expected)
          deferred()

    describe 'basic schema', ->

      it 'can generate very simple query', ->

        Members = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Member"
            schema: ["Name"]

        ajax = expectedQuery '{"from":"Member","select":["Name"]}'

        query = new JsonQuery(url:"url", fetch: ajax)
        query.for(Members)
        query.exec()

      it 'can query with an alias', ->
        alias = V1.alias

        Expressions = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Expression"
            schema: [ alias("Author.Name").as("Speaker") ]

        ajax = expectedQuery '{"from":"Expression","select":["Author.Name"]}'

        query = new JsonQuery(url:"url", fetch: ajax)
        query.for(Expressions)
        query.exec()

      it 'can generate a query with multiple attributes', ->

        Expressions = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Expression"
            schema: ["Author.Name", "Content"]

        ajax = expectedQuery '{"from":"Expression","select":["Author.Name","Content"]}'

        query = new JsonQuery(url:"url", fetch: ajax)
        query.for(Expressions)
        query.exec()

      it 'can generate a query with a relation', ->

        relation = V1.relation

        Author = V1.Model.extend
          assetType: "Member"
          schema: ["Name"]

        Expressions = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Expression"
            schema: [ relation("Author").of(Author) ]

        ajax = expectedQuery "{\"from\":\"Expression\",\"select\":[{\"from\":\"Author as Member\",\"select\":[\"Name\"]}]}"

        query = new JsonQuery(url:"url", fetch: ajax)
        query.for(Expressions)
        query.exec()

      it 'can generate a query with a mutlirelation', ->

        relation = V1.relation

        Replies = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Expression"
            schema: ["Content"]

        Expressions = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Expression"
            schema: [ relation("ExpressionsInConversation").of(Replies) ]

        ajax = expectedQuery "{\"from\":\"Expression\",\"select\":[{\"from\":\"ExpressionsInConversation as Expression\",\"select\":[\"Content\"]}]}"

        query = new JsonQuery(url:"url", fetch: ajax)
        query.for(Expressions)
        query.exec()

    describe "filtering relations", ->

      it 'should be able to filter relations using "filter" clauses', ->

        relation = V1.relation

        Expressions = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Expression"

        Members = V1.Collection.extend
          model: V1.Model.extend
            assetType: "Member"
            schema: [
              relation("ParticipatesInConversations")
                .of(Expressions)
                .as("BigGroups")
                .addFilter("ConversationParticipants.@Count>='2'")
            ]

        ajax = expectedQuery '{"from":"Member","select":[{"from":"ParticipatesInConversations as Expression","filter":["ConversationParticipants.@Count>=\'2\'"]}]}'

        query = new JsonQuery(url:"url", fetch: ajax)
        query.for(Members)
        query.exec()


  describe "getting results", ->

    it 'can get results for a simple query', ->

      Members = V1.Collection.extend
        model: V1.Model.extend
          assetType: "Member"
          schema: ["Name"]

      query = new JsonQuery(url:"url", fetch: recorded)
      query.for(Members)
      query.exec().done (results) ->
        expect(results.length).to.equal(1)
        expect(results[0].length).to.equal(5)
        expect(results[0].at(0).get("Name")).to.equal("Administrator")

    it 'can get results with an alias', ->

      Members = V1.Collection.extend
        model: V1.Model.extend
          assetType: "Member"
          schema: [V1.alias("Name").as("Who")]

      query = new JsonQuery(url:"url", fetch: recorded)
      query.for(Members)
      query.exec().done (results) ->
        expect(results.length).to.equal(1)
        expect(results[0].length).to.equal(5)
        expect(results[0].at(0).get("Who")).to.equal("Administrator")

    it 'can get hydrate results for a relation', ->

      Member = V1.Model.extend
        assetType: "Member"
        schema: ["Name"]

      Expressions = V1.Collection.extend
        model: V1.Model.extend
          assetType: "Expression"
          schema: [ V1.relation("Author").of(Member) ]

      query = new JsonQuery(url:"url", fetch: recorded)
      query.for(Expressions)
      query.exec().done (results) ->
        expect(results.length).to.equal(1)
        expect(results[0].length).to.equal(41)
        expect(results[0].at(0).get("Author").get("Name")).to.equal("Administrator")

    it 'can support deep aliasing', ->

      Member = V1.Model.extend
        assetType: "Member"
        schema: [ V1.alias("Name").as("WhoDat") ]

      Expressions = V1.Collection.extend
        model: V1.Model.extend
          assetType: "Expression"
          schema: [ V1.relation("Author").of(Member) ]

      query = new JsonQuery(url:"url", fetch: recorded)
      query.for(Expressions)
      query.exec().done (results) ->
        expect(results.length).to.equal(1)
        expect(results[0].length).to.equal(41)
        expect(results[0].at(0).get("Author").get("WhoDat")).to.equal("Administrator")

    it 'can support deep relations', ->

      Member = V1.Model.extend
        assetType: "Member"
        schema: [ V1.alias("Name").as("WhoDat") ]

      Reply = V1.Collection.extend
        model: V1.Model.extend
          assetType: "Expression"
          schema: [ V1.relation("Author").of(Member) ]


      Expressions = V1.Collection.extend
        model: V1.Model.extend
          assetType: "Expression"
          schema: [ V1.relation("ExpressionsInConversation").of(Reply).as("Replies") ]

      query = new JsonQuery(url:"url", fetch: recorded)
      query.for(Expressions)
      query.exec().done (results) ->
        expect(results.length).to.equal(1)

        expressions = results[0]
        expect(expressions.length).to.equal(41)
        expect(expressions.at(1).get("Replies")).to.be.an.instanceof(V1.Collection)
        expect(expressions.at(1).get("Replies").at(0).get("Author").get("WhoDat")).to.equal("Administrator")
