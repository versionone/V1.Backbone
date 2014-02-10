V1 = require('../V1.Backbone')
expect = require('chai').expect
deferred = require('Deferred')

describe "Deleteing model", ->
  it "should try to post to the correct url", (done) ->
    persisterOptions =
      url: "/VersionOne/rest-1.v1/Data"
      post: (url, data) ->
        expect(data).to.equal(undefined)
        expect(url).to.equal("/VersionOne/rest-1.v1/Data/Expression/1234?op=Delete")
        deferred().resolve()

    persister = new V1.Backbone.RestPersister(persisterOptions)

    Expression = V1.Backbone.Model.extend
      queryOptions:
        assetType: "Expression"
        persister: persister

    model = new Expression()
    model.id = "Expression:1234"
    model.destroy().done(done)
