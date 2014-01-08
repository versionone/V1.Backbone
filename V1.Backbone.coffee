V1 = if exports? then exports else this.V1 or (this.V1 = {})
_ = if !this?._? then (if require? then require('underscore') else throw "Unable to load/find underscore") else this._
Backbone = if !this?.Backbone? then (if require? then require('Backbone') else throw "Unable to load/find backbone") else this.Backbone

defaultRetriever = undefined
defaultPersister = undefined

syncMethods =
  read: (model, options) ->
    retriever = this.queryOptions?.retriever or options?.retriever or defaultRetriever
    throw "A retriever is required" unless retriever?

    xhr = retriever.into(model, options)
      .done(options.success).fail(options.error)

    model.trigger('request', model, xhr, options);
    xhr

  create: (ctx, options) ->
    persister = this.queryOptions?.persister or options?.persister or defaultPersister
    throw "A persister is required" unless persister?

    xhr = persister.create(ctx, options)
      .fail(options.error)
      .done(options.success)

    ctx.trigger('request', ctx, xhr, options);
    xhr

sync = (method, model, options) ->
  throw "Unsupported sync method: \"#{method}\"" unless syncMethods[method]
  syncMethods[method].call(this, model, options)

isModel = (type) ->
  type::isV1 and type is Backbone.Model or type.prototype instanceof Backbone.Model

isCollection = (type) ->
  type::isV1 and type is Backbone.Collection or type.prototype instanceof Backbone.Collection

isAcceptable = (type) ->
  isModel(type) or isCollection(type)

mixInTo = (cls) ->
  cls::sync = sync
  cls::isV1 = true
  cls::idAttribute = "_oid" if cls::idAttribute?
  cls

V1.Backbone =
  setDefaultRetriever: (options) ->
    defaultRetriever = new V1.Backbone.JsonRetriever(options)

  clearDefaultRetriever: -> defaultRetriever = undefined

  setDefaultPersister: (options) ->
    defaultPersister = new V1.Backbone.RestPersister(options)

  clearDefaultPersister: -> defaultPersister = undefined

  begin: (options) ->
    options = _.extend({}, defaultRetriever?.options, options, {batch: true})
    new V1.Backbone.JsonRetriever(options)

  mixInTo: mixInTo
  Model: mixInTo Backbone.Model.extend()
  Collection: mixInTo Backbone.Collection.extend()

class V1.Backbone.JsonRetriever
  defaultOptions =
    fetch: () -> $.post.apply($, arguments)
    defer: () -> $.Deferred.apply($, arguments)

  validQueryOptions = ["find", "filter", "where", "with"]

  getQueryFor = (type, attribute) ->
    throw "Unsupported type" unless isAcceptable(type)

    protoModel = type.prototype if isModel(type)
    protoModel = type::model.prototype if isCollection(type)

    queryOptions = protoModel.queryOptions

    assetType = queryOptions.assetType or attribute

    query = from: if attribute then "#{attribute} as #{assetType}" else assetType
    addSelectTokens(queryOptions.schema, query)
    addFilterTokens(type, query)
    addFindInTokens(type, query)

    type.prototype.queryMucker?(query) if isCollection(type)

    query

  addRelation = (relation) ->
    subQuery = getQueryFor(relation.type, relation.attribute)
    _.extend(subQuery, _.pick(relation, validQueryOptions))

  safeConcat = (set, newArray) ->
      newArray = if _.isString(newArray) then [newArray] else newArray
      set = set.concat(newArray) if _.isArray(newArray) and newArray.length > 0
      set

  addFilterTokens = (type, query) ->
    filter = []
    filter = safeConcat(filter, type::queryOptions?.filter)
    filter = safeConcat(filter, type::model::queryOptions?.filter) if isCollection(type)

    query.filter = filter if filter.length > 0

  addFindInTokens = (type, query) ->
    findIn = []
    findIn = safeConcat(findIn, type::queryOptions?.findIn)

    query.findIn = findIn if findIn.length > 0

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

    @clear()

  for: (type) ->
    @batchInto(type, getQueryFor(type), @queries.length)
      .pipe (aliasedRows) -> new type(aliasedRows)

  fetch: (instance, options) ->
    options = _.extend({}, options, { retriever: this })
    instance.fetch(options)

  into: (instance, options) ->
    type = instance.constructor
    query = getQueryFor(type)

    _.extend(query, _.pick(options, validQueryOptions))

    instance.queryMucker?(query) if instance.queryMucker? and instance.queryMucker != type.prototype.queryMucker

    if isModel(type)
      throw "`id` is required" unless instance.id
      query.where = _.extend(query.where or {}, ID: instance.id)

    return @batchInto(type, query, @queries.length) if @options.batch

    data = JSON.stringify(query)

    @options.fetch(@options.url, data)
      .pipe((data) -> prepareResultFor(data[0], type))

  findOrCreateBatch: ->
    @currentBatch = @options.defer() unless @currentBatch?
    @currentBatch

  batchInto: (type, query, index) ->
    @queries[index] = query

    @findOrCreateBatch()
      .pipe((results) -> prepareResultFor(results[index], type))

  exec: ->
    return unless @currentBatch

    data = _(this.queries)
      .map((q) -> JSON.stringify(q))
      .join("\n---\n");

    @options.fetch(@options.url, data)
      .done(@resolveBatch)

  resolveBatch: (data) =>
    @currentBatch.resolve(data)
    @clear()

  clear: =>
    @queries = []
    @currentBatch = undefined

  prepareResultFor = (data, type) ->
    rows = aliasRows(data, type)
    return rows if isCollection(type)
    return rows[0] if isModel(type)

  aliasRows = (rows, type) ->
    schema = if isModel(type)
    then type::queryOptions?.schema
    else type::model::queryOptions?.schema

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

class V1.Backbone.RestPersister
  url = _.template("<%= baseUrl %>/<%= assetType %><% if(typeof(id) != \"undefined\") { %>/<%= id %><% } %>")

  defaultOptions =
    post: (url, data) ->
      $.ajax
        type: "POST"
        url: url,
        data: data,
        dataType: "text"

    defer: () -> $.Deferred.apply($, arguments)

  url: (assetType, id) =>
    url({baseUrl: @options.url, assetType: assetType, id: id})

  constructor: (options) ->
    throw "url required" unless options?.url?
    @options = _.extend({}, defaultOptions, options)

  create: (ctx, options) ->
    throw "Unsupported context" unless isModel(ctx.constructor)
    changes = ctx.changedAttributes()

    toAttribute = (attribute, alias) ->
      value = changes[alias]
      return unless value?
      "<Attribute name=\"#{_.escape(attribute)}\" act=\"set\">#{_.escape(changes[alias])}</Attribute>"

    toSingleRelation = (relation) ->
      value = changes[relation.alias]
      return unless value?
      oid = value.id
      "<Relation name=\"#{_.escape(relation.attribute)}\" act=\"set\"><Asset idref=\"#{_.escape(oid)}\" /></Relation>"

    attr = _(ctx.queryOptions.schema)
      .chain()
      .map((item) ->
        return toSingleRelation(item) if item instanceof Relation and item.isSingle()
        return if item instanceof Relation
        return toAttribute(item.attribute, item.alias) if item instanceof Alias
        return toAttribute(item, item) if _.isString(item)
      )
      .value()
      .join("")

    asset = "<Asset>#{attr}</Asset>"

    @options.post(@url(ctx.queryOptions.assetType, ctx.id), asset)
      .done((data) -> ctx.id = result[1] if result = /id="(\w+:\d+):\d+"/.exec(data))

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
  constructor: (@attribute) ->
    super(@attribute)
    @type = V1.Backbone.Collection

  isMulti: ->
    isCollection(@type)

  isSingle: ->
    isModel(@type)

  of: (type) ->
    throw "Unsupported type must be a V1.Backbone.Model or a V1.Backbone.Collection" unless isAcceptable(type)
    aug.extend(this, {type})

  addFilter: (filters...) ->
    aug.add(this, "filter", filters)

  addWhere: (where) ->
    aug.merge(this, {where})

  addWith: (newWith) ->
    aug.merge(this, {newWith})

V1.Backbone.relation = (attribute) -> new Relation(attribute)
