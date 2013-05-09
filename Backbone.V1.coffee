V1 = if exports? then exports else (V1 || {})
_ = require('underscore') if !_? and require?
Backbone = require('Backbone') if !Backbone? and require?

class V1.Model extends Backbone.Model
class V1.Collection extends Backbone.Collection

class V1.JsonQuery
  defaultOptions = { fetcher: (url, data) -> $.post(url, data) }

  getQueryFor = (type, attribute) ->
    protoModel = if type.prototype instanceof V1.Collection then type.prototype.model.prototype else type.prototype

    assetType = protoModel.assetType

    {
      from: if attribute then "#{attribute} as #{assetType}" else assetType,
      select: getSelectTokens(protoModel.schema)
    }

  getSelectTokens = (schema) ->
    _(schema).map (item) ->
      return item.attribute if item instanceof Alias
      return getQueryFor(item.type, item.attribute) if item instanceof Relation
      return item if _.isString(item)

  constructor: (options) ->
    throw "url required" unless options?.url?

    @options = _.extend({}, defaultOptions, options)

    @types = []
    @queries = []

  for: (type) ->
    @types.push(type)
    @queries.push(getQueryFor(type))

  exec: ->
    data = _(this.queries)
      .map((q) -> JSON.stringify(q))
      .join("\n---\n");

    @options.fetcher(@options.url, data)


  ### Relation Helpers ###

  class Alias
    constructor: (@attribute) ->
      @alias = @attribute

    as: (alias) ->
      @alias = alias
      this

  @alias = (attribute) -> new Alias(attribute)

  class Relation
    constructor: (@attribute) ->
      @type = V1.Collection

    isMulti: ->
      @type.prototype instanceof V1.Collection or @type is V1.Collection

    isSingle: ->
      @type.prototype instanceof V1.Model or @type is V1.Model

    as: (type) ->
      throw "Unsupported type must be a V1.Model or a V1.Collection" unless type.prototype instanceof V1.Model or type.prototype instanceof V1.Collection
      @type = type
      this

  @relation = (attribute) -> new Relation(attribute)
