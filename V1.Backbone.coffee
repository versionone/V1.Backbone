V1 = if exports? then exports else (window.V1 ||= {})
_ = require('underscore') if !_? and require?
Backbone = require('Backbone') if !Backbone? and require?

defaultQuerier = undefined

V1.Backbone =
  setDefaultInstance: (options) ->
    defaultQuerier = new V1.Backbone.JsonQuery(options)

  clearDefaultInstance: -> defaultQuerier = undefined

sync = (method, model, options) ->
  throw "Unsupported method: #{method}" unless method is "read"

  querier = this.querier or defaultQuerier
  throw "A querier is required" unless querier?

  querier.into(model, options)
    .done(options.success).fail(options.error)


class V1.Backbone.Model extends Backbone.Model
  idAttribute: "_oid"
  sync: sync

class V1.Backbone.Collection extends Backbone.Collection
  sync: sync


class V1.Backbone.JsonQuery
  defaultOptions = { fetch: (url, data) -> $.post(url, data) }

  validQueryOptions = ["filter", "where"]

  getQueryFor = (type, attribute) ->
    protoModel = if type.prototype instanceof V1.Backbone.Collection then type.prototype.model.prototype else type.prototype

    assetType = protoModel.assetType

    {
      from: if attribute then "#{attribute} as #{assetType}" else assetType,
      select: getSelectTokens(protoModel.schema)
    }

  getSelectTokens = (schema) ->
    return [schema] if _.isString(schema)

    _(schema).map (item) ->
      return getQueryFor(item.type, item.attribute) if item instanceof Relation
      return item.attribute if item instanceof Alias
      return item if _.isString(item)

  constructor: (options) ->
    throw "url required" unless options?.url?

    @options = _.extend({}, defaultOptions, options)

    @types = []
    @queries = []

  for: (type) ->
    @types.push(type)
    @queries.push(getQueryFor(type))

  into: (instance, options) ->
    type = instance.constructor
    query = getQueryFor(type)

    _.extend(query, _.pick(options, validQueryOptions))

    if (instance instanceof V1.Backbone.Model)
      throw "`id` is required" unless instance.id
      (query.where || query.where = {}).ID = instance.id

    data = JSON.stringify(query)

    @options.fetch(@options.url, data)
      .pipe(_.bind(prepareResultFor, type))

  exec: ->
    data = _(this.queries)
      .map((q) -> JSON.stringify(q))
      .join("\n---\n");

    @options.fetch(@options.url, data)
      .pipe(_.bind(transformResults, @types))

  transformResults = (data) ->
    _(data).map(transformRows, this)

  prepareResultFor = (data) ->
    rows = aliasRows(data[0], this)
    return rows if this.prototype instanceof V1.Backbone.Collection
    return rows[0] if this.prototype instanceof V1.Backbone.Model

  transformRows = (rows, index) ->
    type = this[index]
    new type(aliasRows(rows, type))

  aliasRows = (rows, type) ->
    schema = if type.prototype instanceof V1.Backbone.Model
    then type.prototype.schema
    else type.prototype.model.prototype.schema

    schema = [schema] if _.isString(schema)

    _(rows).map (row) ->
      transformedRow = { "_oid": row["_oid"] }
      _(schema).each (item) ->
        if(_.isString(item))
          transformedRow[item] = row[item]
        else if(item instanceof Alias)
          if(item instanceof Relation)
            children = aliasRows(row[item.attribute], item.type)
            transformedRow[item.alias] = new item.type(children[0]) if item.isSingle() && children[0]?
            transformedRow[item.alias] = new item.type(children) if item.isMulti()
          else
            transformedRow[item.alias] = row[item.attribute]

      transformedRow

### Relation Helpers ###

class Alias
  constructor: (@attribute) ->
    @alias = @attribute

  as: (alias) ->
    @alias = alias
    this

V1.Backbone.alias = (attribute) -> new Alias(attribute)

class Relation extends Alias
  constructor: (@attribute) ->
    super(@attribute)
    @type = V1.Backbone.Collection

  isMulti: ->
    @type.prototype instanceof V1.Backbone.Collection or @type is V1.Backbone.Collection

  isSingle: ->
    @type.prototype instanceof V1.Backbone.Model or @type is V1.Backbone.Model

  of: (type) ->
    throw "Unsupported type must be a V1.Backbone.Model or a V1.Backbone.Collection" unless type.prototype instanceof V1.Backbone.Model or type.prototype instanceof V1.Backbone.Collection
    @type = type
    this

V1.Backbone.relation = (attribute) -> new Relation(attribute)
