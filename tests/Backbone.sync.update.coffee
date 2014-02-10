V1 = require('../V1.Backbone')
expect = require('chai').expect
deferred = require('Deferred')

describe "Updating model", ->
  it "should try to post to the correct url", (done) ->
    persisterOptions =
      url: "/VersionOne/rest-1.v1/Data"
      post: (url, data) ->
        expect(data).to.equal('<Asset><Attribute name="Name" act="set">Bobby</Attribute></Asset>')
        expect(url).to.equal("/VersionOne/rest-1.v1/Data/Member/1234")
        deferred().resolve()

    persister = new V1.Backbone.RestPersister(persisterOptions)

    Member = V1.Backbone.Model.extend
      queryOptions:
        assetType: "Member"
        schema: [V1.Backbone.alias("Name").as("name")]
        persister: persister

    model = new Member()
    model.id = "Member:1234"
    model.save({name:"Bobby"}).done(done)
