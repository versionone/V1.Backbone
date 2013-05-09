V1 = if exports? then exports else (V1 || {})
_ = require('underscore') if !_? and require?
Backbone = require('Backbone') if !Backbone? and require?

class V1.JsonQuery
  defaultOptions = { fetcher: (url, data) -> $.post(url, data) }

  getQueryFor = (type, as) ->
    protoModel = type.prototype.model.prototype
    assetType = protoModel.assetType

    {
      from: assetType
      select: getSelectTokens(protoModel.schema)
    }

  getSelectTokens = (schema) ->
    _(schema).values()


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