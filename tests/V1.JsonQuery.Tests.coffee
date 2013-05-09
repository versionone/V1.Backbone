JsonQuery = require('../Backbone.V1').JsonQuery
expect = require('chai').expect
Backbone = require('backbone')
deferred = require('Deferred')

mockAjax = (results) ->
  -> deferred().resolve(results)

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

      query = new JsonQuery(url:actualUrl, fetcher: fetcher)
      query.exec()

  describe 'converting a backbone model to a query', ->

    describe 'a single query', ->

      it 'generate a simple query', ->
        Member = Backbone.Model.extend
          assetType: "Member"
          schema: ["Name"]

        Members = Backbone.Model.extend(model:Member)

        results = []

        queryChecker = (url, data) ->
          expect(data).to.equal '{"from":"Member","select":["Name"]}'


        query = new JsonQuery(url:"url", fetcher: queryChecker)
        query.for(Members)
        query.exec()

      it 'query with an alias', ->

        alias = JsonQuery.alias

        Expression = Backbone.Model.extend
          assetType: "Expression"
          schema: [ alias("Author.Name").as("Speaker") ]

        Expressions = Backbone.Model.extend(model:Expression)

        results = []

        queryChecker = (url, data) ->
          expect(data).to.equal '{"from":"Expression","select":["Author.Name"]}'


        query = new JsonQuery(url:"url", fetcher: queryChecker)
        query.for(Expressions)
        query.exec()
