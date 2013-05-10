V1 = if exports? then exports else (window.V1 ||= {})
_ = if !window?._? then (if require? then require('underscore') else throw "Unable to load/find underscore") else window._
Backbone = if !window?.Backbone? then (if require? then require('Backbone') else throw "Unable to load/find backbone") else window.Backbone

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

    assetType = protoModel.assetType or attribute

    query = from: if attribute then "#{attribute} as #{assetType}" else assetType
    addSelectTokens(protoModel.schema, query)

    query

  addRelation = (relation) ->
    subQuery = getQueryFor(relation.type, relation.attribute)
    _.extend(subQuery, _.pick(relation, validQueryOptions))

  addSelectTokens = (schema, query) ->
    return query.select = [schema] if _.isString(schema)
    return unless schema? and schema.length > 0
    query.select = _(schema).map (item) ->
      return addRelation(item) if item instanceof Relation
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

aug = (target, action) ->
  Dup = ->
  Dup.prototype = target
  _(new Dup()).tap(action || ->)

aug.extend = (target, props) ->
  aug target, (augmentedResult) -> _.extend(augmentedResult, props)

aug.add = (target, property, values) ->
  aug target, (augmentedResult) ->
    augmentedResult[property] = if _.isArray(target[property]) then target[property].concat(values) else values

aug.merge = (target, props) ->
  aug target, (augmentedResult) ->
    _(props).each (val, key) -> target[key] = _.extend(val, target[key])

class Alias
  constructor: (@attribute) ->
    @alias = @attribute

  as: (alias) ->
    aug.extend(this, {alias})

V1.Backbone.alias = (attribute) -> new Alias(attribute)

class Relation extends Alias

  isAcceptable = (type) ->
    type.prototype instanceof V1.Backbone.Model or
    type.prototype instanceof V1.Backbone.Collection or
    type is V1.Backbone.Collection or
    type is V1.Backbone.Model

  constructor: (@attribute) ->
    super(@attribute)
    @type = V1.Backbone.Collection

  isMulti: ->
    @type.prototype instanceof V1.Backbone.Collection or @type is V1.Backbone.Collection

  isSingle: ->
    @type.prototype instanceof V1.Backbone.Model or @type is V1.Backbone.Model

  of: (type) ->
    throw "Unsupported type must be a V1.Backbone.Model or a V1.Backbone.Collection" unless isAcceptable(type)
    aug.extend(this, {type})

  addFilter: (filters...) ->
    aug.add(this, "filter", filters)

  addWhere: (where) ->
    aug.merge(this, {where})

V1.Backbone.relation = (attribute) -> new Relation(attribute)
