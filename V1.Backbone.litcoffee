V1.Backbone
===========

A simple backbone adapter for V1 queries.

Base Setup
----------

Establish and import some required global objects.

    V1 = if exports? then exports else this.V1 or (this.V1 = {})
    _ = if !this?._? then (if require? then require('underscore') else throw new Error("Unable to load/find underscore")) else this._
    Backbone = if !this?.Backbone? then (if require? then require('backbone') else throw new Error("Unable to load/find backbone")) else this.Backbone

Create a `property` helper bound to a specified property.

This returns a function which can be invoked with one or more objects.
It will loop through though arguments and return value from the first object
which has the desired property. A `defaultValue` can be specified if no matching
property can not be found.

The returned function also provides a `safe()` getter which will throw an
exception if value cannot be found -- rather than returning `defaultValue`.

The returned function also provides a `set()` function for setting the
underlying default value.

    createProperty = (property, defaultValue) ->
      getter = () ->
        for arg in arguments
          return arg[property] if arg?[property]?
        defaultValue

      _(getter).tap (getter) ->
        getter.safe = () ->
          val = getter.apply(this, arguments)
          throw new Error("A "+property+" is required") unless val?
          val

        getter.set = (val) -> defaultValue = val

Create property getters for the `retriever` and the `persister`.

    defaultRetriever = createProperty("retriever")
    defaultPersister = createProperty("persister")

This is the default `sync` method for all `V1.Backbone` objects. This
method proxies most of its work into the configured `retriever` and
`persister`. Which are usually instances of `V1.Backbone.JsonRetiever` and
`V1.Backbone.RestPersister` respectively.

    sync = do ->
      methods = do ->
        syncToPersisterMethod = (method) ->
          (ctx, options) ->
            persister = defaultPersister.safe(this.queryOptions, options)

            xhr = persister[method](ctx, options)
              .fail(options.error)
              .done(options.success)

            ctx.trigger('request', ctx, xhr, options);
            xhr

        readFromRetriever = (model, options) ->
          retriever = defaultRetriever.safe(this.queryOptions, options)

          xhr = retriever.into(model, options)
            .done(options.success).fail(options.error)

          model.trigger('request', model, xhr, options);
          xhr

        read: readFromRetriever
        create: syncToPersisterMethod("send")
        update: syncToPersisterMethod("send")
        delete: syncToPersisterMethod("delete")


      (method, model, options) ->
        throw new Error("Unsupported sync method: \"#{method}\"") unless methods[method]
        methods[method].call(this, model, options)

Helpers
-------

These are helper methods for determining types.

    isModel = (type) ->
      type::isV1 and (type is Backbone.Model or type.prototype instanceof Backbone.Model)

    isCollection = (type) ->
      type::isV1 and (type is Backbone.Collection or type.prototype instanceof Backbone.Collection)

    isAcceptable = (type) ->
      isModel(type) or isCollection(type)

A utility function to mix `V1.Backbone` functionality into an existing `Backbone.Model` or
`Backbone.Collection`. This can be useful for enviroments where the `V1.Backbone` dependancy
is not available at object construction time, you can use this to mix in the `V1.Backbone`
extensions at a later time.

    mixInTo = (cls) ->
      _(cls).tap (cls) ->
        cls::sync = sync
        cls::isV1 = true
        cls::idAttribute = "_oid" if cls::idAttribute?

Main
----

This is the main `V1.Backbone` namespace.

    V1.Backbone =

Set the *global* default retriever options.

      setDefaultRetriever: (options) ->
        defaultRetriever.set(new V1.Backbone.JsonRetriever(options))

Clear the *global* default retriever -- useful for test contexts.

      clearDefaultRetriever: -> defaultRetriever.set(undefined)

Set the *global* default persister options.

      setDefaultPersister: (options) ->
        defaultPersister.set(new V1.Backbone.RestPersister(options))

Clear the *global* default persister -- useful for test contexts.

      clearDefaultPersister: -> defaultPersister.set(undefined)

Begin a batch transaction. You can queue up multiple queries during one HTTP request
with this method.



> Note: Be sure to remember to wait for the deferred object to be
resolved before attempting to use the data.

      begin: (options) ->
        options = _.extend({}, defaultRetriever()?.options, options, {batch: true})
        new V1.Backbone.JsonRetriever(options)

Export the `mixInTo` helper.

      mixInTo: mixInTo

      Model: mixInTo Backbone.Model.extend()
      Collection: mixInTo Backbone.Collection.extend()

Retrieval
--------

    class V1.Backbone.JsonRetriever
      defaultOptions =
        fetch: () -> $.post.apply($, arguments)
        defer: () -> $.Deferred.apply($, arguments)

      validQueryOptions = ["find", "filter", "where", "with"]

      getQueryFor = (type, attribute) ->
        throw new Error("Unsupported type") unless isAcceptable(type)

        protoModel = type.prototype if isModel(type)
        protoModel = type::model.prototype if isCollection(type)

        queryOptions = protoModel.queryOptions

        assetType = queryOptions.assetType or attribute

        query = from: if attribute then "#{attribute} as #{assetType}" else assetType

        addSorts(type::queryOptions.sort, query) if isCollection(type) and type::queryOptions?
        addSelectTokens(queryOptions.schema, query)
        addFilterTokens(type, query)
        addWithTokens(type, query)
        addFindInTokens(type, query)

        type.queryMucker?(query) if isCollection(type)

        query

      addRelation = (relation) ->
        subQuery = getQueryFor(relation.type, relation.attribute)
        _.extend(subQuery, _.pick(relation, validQueryOptions))

      safeConcat = (set, newArray) ->
          newArray = if _.isString(newArray) then [newArray] else newArray
          set = set.concat(newArray) if _.isArray(newArray) and newArray.length > 0
          set

      addSorts = (sort, query) ->
        query.sort = sort if sort?

      addFilterTokens = (type, query) ->
        filter = []
        filter = safeConcat(filter, type::queryOptions?.filter)
        filter = safeConcat(filter, type::model::queryOptions?.filter) if isCollection(type)

        query.filter = filter if filter.length > 0

      addFindInTokens = (type, query) ->
        findIn = []
        findIn = safeConcat(findIn, type::queryOptions?.findIn)

        query.findIn = findIn if findIn.length > 0

      addWithTokens = (type, query) ->
        withToken = type::queryOptions?.with
        query.with ?= withToken

      addSelectTokens = (schema, query) ->
        return query.select = [schema] if _.isString(schema)
        return unless schema? and schema.length > 0
        query.select = _(schema).map (item) ->
          return addRelation(item) if item instanceof Relation
          return item.attribute if item instanceof Alias
          return item if _.isString(item)

      constructor: (options) ->
        throw new Error("url required") unless options?.url?

        @options = _.extend({}, defaultOptions, options)

        @clear()

      for: (type) ->
        @batchInto(type, getQueryFor(type), @queries.length)
          .then (aliasedRows) -> new type(aliasedRows)

      fetch: (instance, options) ->
        options = _.extend({}, options, { retriever: this })
        instance.fetch(options)

      into: (instance, options) ->
        type = instance.constructor
        query = getQueryFor(type)

        _.extend(query, _.pick(options, validQueryOptions))

        instance.queryMucker?(query) if instance.queryMucker? and instance.queryMucker != type.prototype.queryMucker

        if isModel(type)
          throw new Error("`id` is required") unless instance.id
          query.where = _.extend(query.where or {}, ID: instance.id)

        return @batchInto(type, query, @queries.length) if @options.batch

        data = JSON.stringify(query)

        xhr = @options.fetch(@options.url, data)

        deferred = xhr.then (data) -> prepareResultFor(data[0], type)
        deferred.abort = _.bind(xhr.abort, xhr) if xhr.abort? and !deferred.abort?

        deferred


      findOrCreateBatch: ->
        @currentBatch = @options.defer() unless @currentBatch?
        @currentBatch

      batchInto: (type, query, index) ->
        @queries[index] = query

        @findOrCreateBatch()
          .then((results) -> prepareResultFor(results[index], type))

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

Persistance
-----------

    class V1.Backbone.RestPersister
      urlTmpl = _.template("<%= baseUrl %>/<%= assetType %><% if(typeof(id) != \"undefined\") { %>/<%= id %><% } %>")

      toAttribute = (attribute, value) ->
        "<Attribute name=\"#{_.escape(attribute)}\" act=\"set\">#{_.escape(value)}</Attribute>"

      toSingleRelation = (attribute, oid) ->
        "<Relation name=\"#{_.escape(attribute)}\" act=\"set\"><Asset idref=\"#{_.escape(oid)}\" /></Relation>"

      defaultOptions =
        post: (url, data) ->
          $.ajax
            type: "POST"
            url: url,
            data: data,
            dataType: "text"

      url: (assetType, oid) =>
        oidParts = if oid? then oid.split(":") else []
        urlTmpl({baseUrl: @options.url, assetType: oidParts[0] or assetType, id: oidParts[1]})

      constructor: (options) ->
        throw new Error("url required") unless options?.url?
        @options = _.extend({}, defaultOptions, options)

      delete: (ctx, options) ->
        throw new Error("Unsupported context") unless isModel(ctx.constructor)
        options = options || {}
        attr = options.attrs || ctx.toJSON(options)
        @options.post(@url(ctx.queryOptions.assetType, ctx.id)+"?op=Delete")

      send: (ctx, options) ->
        send = if options.patch is yes then @sendPatch else @sendAll
        send.apply(this, arguments)

      sendPatch: (ctx, options) ->
        schema = _.indexBy ctx.queryOptions.schema, (val) ->
          if (val instanceof Alias) then val.alias else val

        toXml = (val, key) ->
          item = schema[key] || key
          return toSingleRelation(item.attribute, attr[item.alias].id) if item instanceof Relation and item.isSingle() and attr[item.alias]?
          return if item instanceof Relation
          return toAttribute(item.attribute, val) if item instanceof Alias
          return toAttribute(item, val) if _.isString(item)

        attrXml = _.map(ctx.changedAttributes(), toXml).join("")
        asset = "<Asset>#{attrXml}</Asset>"
        url = @url(ctx.queryOptions.assetType, ctx.id)
        @options.post(url, asset)

      sendAll: (ctx, options) ->
        throw new Error("Unsupported context") unless isModel(ctx.constructor)
        options = options || {}
        attr = options.attrs || ctx.toJSON(options)

        toXml = (item) ->
          return toSingleRelation(item.attribute, attr[item.alias].id) if item instanceof Relation and item.isSingle() and attr[item.alias]?
          return if item instanceof Relation
          return toAttribute(item.attribute, attr[item.alias]) if item instanceof Alias
          return toAttribute(item, attr[item]) if _.isString(item)

        attrXml = _.map(ctx.queryOptions.schema, toXml).join("")

        asset = "<Asset>#{attrXml}</Asset>"
        url = @url(ctx.queryOptions.assetType, ctx.id)
        @options.post(url, asset)
          .done((data) -> ctx.id = result[1] if result = /id="(\w+:\d+):\d+"/.exec(data))

Relation Helpers
----------------

    aug = do ->
      fn = (target, action) ->
        Dup = ->
        Dup.prototype = target
        _(new Dup()).tap(action || ->)

      _(fn).tap (fn) ->
        fn.extend = (target, props) ->
          aug target, (augmentedResult) -> _.extend(augmentedResult, props)

        fn.add = (target, property, values) ->
          aug target, (augmentedResult) ->
            augmentedResult[property] = if _.isArray(target[property]) then target[property].concat(values) else values

        fn.merge = (target, props) ->
          aug target, (augmentedResult) ->
            _(props).each (val, key) -> target[key] = _.extend(val, target[key])

Alias Helper
------------

    class Alias
      constructor: (@attribute) ->
        @alias = @attribute

      as: (alias) ->
        aug.extend(this, {alias})

Export a simple constructor as `V1.Backbone.alias`

    V1.Backbone.alias = (attribute) -> new Alias(attribute)

Relation Helper
---------------

    class Relation extends Alias
      constructor: (@attribute) ->
        super(@attribute)
        @type = V1.Backbone.Collection

      isMulti: ->
        isCollection(@type)

      isSingle: ->
        isModel(@type)

      of: (type) ->
        throw new Error("Unsupported type must be a V1.Backbone.Model or a V1.Backbone.Collection") unless isAcceptable(type)
        aug.extend(this, {type})

      addFilter: (filters...) ->
        aug.add(this, "filter", filters)

      addWhere: (where) ->
        aug.merge(this, {where})

      addWith: (newWith) ->
        aug.merge(this, {newWith})

Export a simple constructor as `V1.Backbone.relation`

    V1.Backbone.relation = (attribute) -> new Relation(attribute)
