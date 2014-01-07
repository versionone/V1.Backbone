V1 = require('../V1.Backbone')

JsonQuery = V1.JsonQuery

expect = require('chai').expect
Backbone = require('backbone')
recorded = require('./recorded')
spy = require('sinon').spy

deferred = require('Deferred')

describe "Batching backbone fetches", ->

  Members = V1.Backbone.Collection.extend
    model: V1.Backbone.Model.extend
      queryOptions:
        assetType: "Member"

  ExpressionSpaces = V1.Backbone.Collection.extend
    model: V1.Backbone.Model.extend
      queryOptions:
        assetType: "ExpressionSpace"

  it "should not make any requests before `exec()` has been called", ->

    members = new Members()
    spaces = new ExpressionSpaces()

    fetcher = spy()

    transaction = V1.Backbone.begin({url:"url", defer: deferred, fetch: fetcher })
    transaction.fetch(members)
    transaction.fetch(spaces)

    expect(fetcher.called).to.be.false

  it "should make one request after `exec()` has been called", ->

    members = new Members()
    spaces = new ExpressionSpaces()

    fetcher = spy(-> deferred() )

    transaction = V1.Backbone.begin({url:"url", defer: deferred, fetch: fetcher })
    transaction.fetch(members)
    transaction.fetch(spaces)
    transaction.exec()

    expect(fetcher.calledOnce).to.be.true

  it "should make a correctly formed request", () ->

    members = new Members()
    spaces = new ExpressionSpaces()

    expectedData = "{\"from\":\"Member\"}\n---\n{\"from\":\"ExpressionSpace\"}"

    fetcher = (url, data) ->
      expect(data).to.equal(expectedData)
      deferred()


    transaction = V1.Backbone.begin({url:"url", defer: deferred, fetch: fetcher })
    transaction.fetch(members)
    transaction.fetch(spaces)
    transaction.exec()

  it "should make a fill in the right data", () ->

    members = new Members()
    spaces = new ExpressionSpaces()

    expectedData = "{\"from\":\"Member\"}\n---\n{\"from\":\"ExpressionSpace\"}"

    transaction = V1.Backbone.begin({url:"url", defer: deferred, fetch: recorded })
    transaction.fetch(members)
    transaction.fetch(spaces)
    transaction.exec()

    expect(members.length).to.equal(5)
    expect(spaces.length).to.equal(16)


