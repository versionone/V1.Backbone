V1 = require('../V1.Backbone')
expect = require('chai').expect
recorded = require('./recorded')
deferred = require('Deferred')

alias = V1.Backbone.alias
relation = V1.Backbone.relation

describe "Creating with `sync`", ->

  createPersister = (post) ->
    new V1.Backbone.RestPersister({url: "/VersionOne/rest-1.v1/Data", post})

  describe "the url", ->

    expectedUrl = (expectedUrl) ->
      (url, data) ->
        expect(url).to.equal(expectedUrl)
        deferred().resolve()

    it "should be generated correctly", ->
      persister = createPersister expectedUrl "/VersionOne/rest-1.v1/Data/Expression"

      Expression = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Expression"
          persister: persister

      expression = new Expression()
      expression.save()

  describe "the generated XML", ->

    expectedPost = (expectedData) ->
      (url, data) ->
        expect(data).to.equal(expectedData)
        deferred().resolve()

    it "can set simple attributes", (done) ->

      persister = createPersister expectedPost "<Asset><Attribute name=\"Content\" act=\"set\">Hello</Attribute></Asset>"

      Expression = V1.Backbone.Model.extend
        queryOptions:
          persister: persister
          schema: ["Content"]

      expression = new Expression()
      expression.set("Content", "Hello")
      expression.save().done(done)

    it "can set complex attributes", (done) ->

      persister = createPersister expectedPost '<Asset><Attribute name="Content" act="set">Hello</Attribute><Attribute name="Name" act="set">World</Attribute></Asset>'

      Expression = V1.Backbone.Model.extend
        queryOptions:
          persister: persister
          schema: ["Content", "Name"]

      expression = new Expression()
      expression.set({"Content":"Hello", "Name":"World"})
      expression.save().done(done)

    it "can set multiple attributes", (done) ->

      persister = createPersister expectedPost '<Asset><Attribute name="Content" act="set">Hello</Attribute><Attribute name="Name" act="set">World</Attribute></Asset>'

      Expression = V1.Backbone.Model.extend
        queryOptions:
          persister: persister
          schema: ["Content", "Name"]

      expression = new Expression()
      expression.set("Content", "Hello")
      expression.set("Name", "World")
      expression.save().done(done)

    it "can handle attributes passed in as options", (done) ->

      persister = createPersister expectedPost '<Asset><Attribute name="Content" act="set">Hello</Attribute><Attribute name="Name" act="set">World</Attribute></Asset>'

      Expression = V1.Backbone.Model.extend
        queryOptions:
          persister: persister
          schema: ["Content", "Name"]

      expression = new Expression()

      persister.create(expression,{attrs:{"Content":"Hello", "Name":"World"}}).done(done)

    it "can handle aliases of attributes", (done) ->

      persister = createPersister expectedPost "<Asset><Attribute name=\"Content\" act=\"set\">Hello</Attribute></Asset>"

      Expression = V1.Backbone.Model.extend
        queryOptions:
          persister: persister
          schema: [ alias("Content").as("words") ]

      expression = new Expression()
      expression.set("words", "Hello")
      expression.save().done(done)

    it "can handle single-value relations", (done) ->
      persister = createPersister expectedPost "<Asset><Relation name=\"Author\" act=\"set\"><Asset idref=\"Member:20\" /></Relation></Asset>"

      Member = V1.Backbone.Model.extend()

      Expression = V1.Backbone.Model.extend
        queryOptions:
          persister: persister
          schema: [
            alias("Content").as("words")
            relation("Author").of(Member)
          ]

      expression = new Expression()
      expression.set("Author", new Member(_oid:"Member:20"))
      expression.save().done(done)

  describe "setting the ID", ->

    it "should get the right url", (done) ->
      persister = createPersister recorded

      Expression = V1.Backbone.Model.extend
        queryOptions:
          assetType: "Expression"
          persister: persister

      expression = new Expression()
      expression.save().done ->
        expect(expression.id).to.equal("Expression:1114")
        done()
