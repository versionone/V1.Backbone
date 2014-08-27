Backbone = require('backbone')
V1 = require('../V1.Backbone')
expect = require('chai').expect
recorded = require('./recorded')
deferred = require('JQDeferred')

describe "Fetching a sorted collection", ->

  it "adds the sort option to the query from queryOptions", (done) ->
    Members = V1.Backbone.Collection.extend
      queryOptions:
        sort: ["Name"]
      model: V1.Backbone.Model.extend
        queryOptions:
          assetType: "Member"
          schema: [ "Name" ]

    retrieverOptions =
      url: "/VersionOne/query.v1"
      defer: () -> deferred()
      fetch: (url, data) ->
        actual = JSON.parse(data).sort
        expected = ["Name"]
        expect(actual).to.eql(expected)
        deferred().resolve([[]])

    retriever = new V1.Backbone.JsonRetriever(retrieverOptions)

    members = new Members()
    members.fetch({retriever}).done(-> done())

  it "it respects the sort order", (done) ->

    Iterations = V1.Backbone.Collection.extend
      queryOptions:
        sort: ["EndDate"]
      model: V1.Backbone.Model.extend
        queryOptions:
          assetType: "Timebox"
          schema: ["Name"]

    retrieverOptions =
      url: "url"
      defer: deferred
      fetch: recorded

    retriever = new V1.Backbone.JsonRetriever(retrieverOptions)

    iterations = new Iterations()

    verify = ->
      actual = iterations.pluck("Name")
      expected = [ 'Iteration 5','Sprint 1','Month 1','Sprint 2','Sprint 3','Sprint 4','Month 2','Sprint 5','Kanban','Sprint 6','Month 3','Sprint 7','Iteration 4' ]
      expect(actual).to.eql(expected)

    retriever.options.url = "url1"
    iterations.fetch({retriever})
    .then ->
      retriever.options.url = "url2"
      iterations.fetch({retriever})
    .done verify
    .done -> done()
