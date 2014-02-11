V1 = require('../V1.Backbone')
expect = require('chai').expect
deferred = require('Deferred')

describe "Updating model", ->

  createPersister = (fn) ->
    persisterOptions =
      url: "/VersionOne/rest-1.v1/Data"
      post: ->
        fn.apply(this, arguments)
        deferred().resolve()
    new V1.Backbone.RestPersister(persisterOptions)


  getModel = (persister) ->
    V1.Backbone.Model.extend
      queryOptions:
        assetType: "Member"
        schema: [V1.Backbone.alias("Name").as("name"), "Nickname"]
        persister: persister

  it "should try to post to the correct url", (done) ->
    persister = createPersister (url, data) ->
      expect(url).to.equal("/VersionOne/rest-1.v1/Data/Member/1234")

    Member = getModel(persister)

    model = new Member()
    model.id = "Member:1234"
    model.save().done(done)

  it "should send all the properties on save", (done) ->
    persister = createPersister (url, data) ->
      expect(data).to.equal("<Asset><Attribute name=\"Name\" act=\"set\">Bobby</Attribute><Attribute name=\"Nickname\" act=\"set\">Bob</Attribute></Asset>")
    Member = getModel(persister)

    model = new Member()
    model.id = "Member:1234"
    model.set("name", "Bobby")
    model.set("Nickname", "Bob")
    model.save().done(done)

  it "should send changed properties on patch", (done) ->
    persister = createPersister (url, data) ->
      expect(data).to.equal('<Asset><Attribute name="Name" act="set">Robert</Attribute></Asset>')
    Member = getModel(persister)

    model = new Member({_cid:"Member:1234", name:"Bobby", Nickname: "Bob"})
    model.save({"name": "Robert"}, {patch: true}).done(done)