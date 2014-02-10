(function() {
  var Alias, Backbone, Relation, V1, aug, defaultPersister, defaultRetriever, getPeristerFrom, isAcceptable, isCollection, isModel, mixInTo, sync, syncMethods, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  V1 = typeof exports !== "undefined" && exports !== null ? exports : this.V1 || (this.V1 = {});

  _ = (typeof this !== "undefined" && this !== null ? this._ : void 0) == null ? ((function() {
    if (typeof require !== "undefined" && require !== null) {
      return require('underscore');
    } else {
      throw "Unable to load/find underscore";
    }
  })()) : this._;

  Backbone = (typeof this !== "undefined" && this !== null ? this.Backbone : void 0) == null ? ((function() {
    if (typeof require !== "undefined" && require !== null) {
      return require('backbone');
    } else {
      throw "Unable to load/find backbone";
    }
  })()) : this.Backbone;

  defaultRetriever = void 0;

  defaultPersister = void 0;

  getPeristerFrom = function(self, options) {
    var persister, _ref;
    persister = ((_ref = self.queryOptions) != null ? _ref.persister : void 0) || (options != null ? options.persister : void 0) || defaultPersister;
    if (persister == null) {
      throw "A persister is required";
    }
    return persister;
  };

  syncMethods = {
    read: function(model, options) {
      var retriever, xhr, _ref;
      retriever = ((_ref = this.queryOptions) != null ? _ref.retriever : void 0) || (options != null ? options.retriever : void 0) || defaultRetriever;
      if (retriever == null) {
        throw "A retriever is required";
      }
      xhr = retriever.into(model, options).done(options.success).fail(options.error);
      model.trigger('request', model, xhr, options);
      return xhr;
    },
    create: function(ctx, options) {
      var persister, xhr;
      persister = getPeristerFrom(this, options);
      xhr = persister.create(ctx, options).fail(options.error).done(options.success);
      ctx.trigger('request', ctx, xhr, options);
      return xhr;
    },
    "delete": function(ctx, options) {
      var persister, xhr;
      persister = getPeristerFrom(this, options);
      xhr = persister["delete"](ctx, options).fail(options.error).done(options.success);
      ctx.trigger('request', ctx, xhr, options);
      return xhr;
    }
  };

  sync = function(method, model, options) {
    if (!syncMethods[method]) {
      throw "Unsupported sync method: \"" + method + "\"";
    }
    return syncMethods[method].call(this, model, options);
  };

  isModel = function(type) {
    return type.prototype.isV1 && type === Backbone.Model || type.prototype instanceof Backbone.Model;
  };

  isCollection = function(type) {
    return type.prototype.isV1 && type === Backbone.Collection || type.prototype instanceof Backbone.Collection;
  };

  isAcceptable = function(type) {
    return isModel(type) || isCollection(type);
  };

  mixInTo = function(cls) {
    cls.prototype.sync = sync;
    cls.prototype.isV1 = true;
    if (cls.prototype.idAttribute != null) {
      cls.prototype.idAttribute = "_oid";
    }
    return cls;
  };

  V1.Backbone = {
    setDefaultRetriever: function(options) {
      return defaultRetriever = new V1.Backbone.JsonRetriever(options);
    },
    clearDefaultRetriever: function() {
      return defaultRetriever = void 0;
    },
    setDefaultPersister: function(options) {
      return defaultPersister = new V1.Backbone.RestPersister(options);
    },
    clearDefaultPersister: function() {
      return defaultPersister = void 0;
    },
    begin: function(options) {
      options = _.extend({}, defaultRetriever != null ? defaultRetriever.options : void 0, options, {
        batch: true
      });
      return new V1.Backbone.JsonRetriever(options);
    },
    mixInTo: mixInTo,
    Model: mixInTo(Backbone.Model.extend()),
    Collection: mixInTo(Backbone.Collection.extend())
  };

  V1.Backbone.JsonRetriever = (function() {
    var addFilterTokens, addFindInTokens, addRelation, addSelectTokens, aliasRows, defaultOptions, getQueryFor, prepareResultFor, safeConcat, validQueryOptions;

    defaultOptions = {
      fetch: function() {
        return $.post.apply($, arguments);
      },
      defer: function() {
        return $.Deferred.apply($, arguments);
      }
    };

    validQueryOptions = ["find", "filter", "where", "with"];

    getQueryFor = function(type, attribute) {
      var assetType, protoModel, query, queryOptions, _base;
      if (!isAcceptable(type)) {
        throw "Unsupported type";
      }
      if (isModel(type)) {
        protoModel = type.prototype;
      }
      if (isCollection(type)) {
        protoModel = type.prototype.model.prototype;
      }
      queryOptions = protoModel.queryOptions;
      assetType = queryOptions.assetType || attribute;
      query = {
        from: attribute ? "" + attribute + " as " + assetType : assetType
      };
      addSelectTokens(queryOptions.schema, query);
      addFilterTokens(type, query);
      addFindInTokens(type, query);
      if (isCollection(type)) {
        if (typeof (_base = type.prototype).queryMucker === "function") {
          _base.queryMucker(query);
        }
      }
      return query;
    };

    addRelation = function(relation) {
      var subQuery;
      subQuery = getQueryFor(relation.type, relation.attribute);
      return _.extend(subQuery, _.pick(relation, validQueryOptions));
    };

    safeConcat = function(set, newArray) {
      newArray = _.isString(newArray) ? [newArray] : newArray;
      if (_.isArray(newArray) && newArray.length > 0) {
        set = set.concat(newArray);
      }
      return set;
    };

    addFilterTokens = function(type, query) {
      var filter, _ref, _ref1;
      filter = [];
      filter = safeConcat(filter, (_ref = type.prototype.queryOptions) != null ? _ref.filter : void 0);
      if (isCollection(type)) {
        filter = safeConcat(filter, (_ref1 = type.prototype.model.prototype.queryOptions) != null ? _ref1.filter : void 0);
      }
      if (filter.length > 0) {
        return query.filter = filter;
      }
    };

    addFindInTokens = function(type, query) {
      var findIn, _ref;
      findIn = [];
      findIn = safeConcat(findIn, (_ref = type.prototype.queryOptions) != null ? _ref.findIn : void 0);
      if (findIn.length > 0) {
        return query.findIn = findIn;
      }
    };

    addSelectTokens = function(schema, query) {
      if (_.isString(schema)) {
        return query.select = [schema];
      }
      if (!((schema != null) && schema.length > 0)) {
        return;
      }
      return query.select = _(schema).map(function(item) {
        if (item instanceof Relation) {
          return addRelation(item);
        }
        if (item instanceof Alias) {
          return item.attribute;
        }
        if (_.isString(item)) {
          return item;
        }
      });
    };

    function JsonRetriever(options) {
      this.clear = __bind(this.clear, this);
      this.resolveBatch = __bind(this.resolveBatch, this);
      if ((options != null ? options.url : void 0) == null) {
        throw "url required";
      }
      this.options = _.extend({}, defaultOptions, options);
      this.clear();
    }

    JsonRetriever.prototype["for"] = function(type) {
      return this.batchInto(type, getQueryFor(type), this.queries.length).pipe(function(aliasedRows) {
        return new type(aliasedRows);
      });
    };

    JsonRetriever.prototype.fetch = function(instance, options) {
      options = _.extend({}, options, {
        retriever: this
      });
      return instance.fetch(options);
    };

    JsonRetriever.prototype.into = function(instance, options) {
      var data, deferred, query, type, xhr;
      type = instance.constructor;
      query = getQueryFor(type);
      _.extend(query, _.pick(options, validQueryOptions));
      if ((instance.queryMucker != null) && instance.queryMucker !== type.prototype.queryMucker) {
        if (typeof instance.queryMucker === "function") {
          instance.queryMucker(query);
        }
      }
      if (isModel(type)) {
        if (!instance.id) {
          throw "`id` is required";
        }
        query.where = _.extend(query.where || {}, {
          ID: instance.id
        });
      }
      if (this.options.batch) {
        return this.batchInto(type, query, this.queries.length);
      }
      data = JSON.stringify(query);
      xhr = this.options.fetch(this.options.url, data);
      deferred = xhr.pipe(function(data) {
        return prepareResultFor(data[0], type);
      });
      if ((xhr.abort != null) && (deferred.abort == null)) {
        deferred.abort = _.bind(xhr.abort, xhr);
      }
      return deferred;
    };

    JsonRetriever.prototype.findOrCreateBatch = function() {
      if (this.currentBatch == null) {
        this.currentBatch = this.options.defer();
      }
      return this.currentBatch;
    };

    JsonRetriever.prototype.batchInto = function(type, query, index) {
      this.queries[index] = query;
      return this.findOrCreateBatch().pipe(function(results) {
        return prepareResultFor(results[index], type);
      });
    };

    JsonRetriever.prototype.exec = function() {
      var data;
      if (!this.currentBatch) {
        return;
      }
      data = _(this.queries).map(function(q) {
        return JSON.stringify(q);
      }).join("\n---\n");
      return this.options.fetch(this.options.url, data).done(this.resolveBatch);
    };

    JsonRetriever.prototype.resolveBatch = function(data) {
      this.currentBatch.resolve(data);
      return this.clear();
    };

    JsonRetriever.prototype.clear = function() {
      this.queries = [];
      return this.currentBatch = void 0;
    };

    prepareResultFor = function(data, type) {
      var rows;
      rows = aliasRows(data, type);
      if (isCollection(type)) {
        return rows;
      }
      if (isModel(type)) {
        return rows[0];
      }
    };

    aliasRows = function(rows, type) {
      var schema, _ref, _ref1;
      schema = isModel(type) ? (_ref = type.prototype.queryOptions) != null ? _ref.schema : void 0 : (_ref1 = type.prototype.model.prototype.queryOptions) != null ? _ref1.schema : void 0;
      if (_.isString(schema)) {
        schema = [schema];
      }
      return _(rows).map(function(row) {
        var transformedRow;
        transformedRow = {
          "_oid": row["_oid"]
        };
        _(schema).each(function(item) {
          var children;
          if (_.isString(item)) {
            return transformedRow[item] = row[item];
          } else if (item instanceof Alias) {
            if (item instanceof Relation) {
              children = aliasRows(row[item.attribute], item.type);
              if (item.isSingle() && (children[0] != null)) {
                transformedRow[item.alias] = new item.type(children[0]);
              }
              if (item.isMulti()) {
                return transformedRow[item.alias] = new item.type(children);
              }
            } else {
              return transformedRow[item.alias] = row[item.attribute];
            }
          }
        });
        return transformedRow;
      });
    };

    return JsonRetriever;

  })();

  V1.Backbone.RestPersister = (function() {
    var defaultOptions, url;

    url = _.template("<%= baseUrl %>/<%= assetType %><% if(typeof(id) != \"undefined\") { %>/<%= id %><% } %>");

    defaultOptions = {
      post: function(url, data) {
        return $.ajax({
          type: "POST",
          url: url,
          data: data,
          dataType: "text"
        });
      },
      defer: function() {
        return $.Deferred.apply($, arguments);
      }
    };

    RestPersister.prototype.url = function(assetType, oid) {
      var oidParts;
      oidParts = oid != null ? oid.split(":") : [];
      return url({
        baseUrl: this.options.url,
        assetType: oidParts[0] || assetType,
        id: oidParts[1]
      });
    };

    function RestPersister(options) {
      this.url = __bind(this.url, this);
      if ((options != null ? options.url : void 0) == null) {
        throw "url required";
      }
      this.options = _.extend({}, defaultOptions, options);
    }

    RestPersister.prototype["delete"] = function(ctx, options) {
      var attr;
      if (!isModel(ctx.constructor)) {
        throw "Unsupported context";
      }
      options = options || {};
      attr = options.attrs || ctx.toJSON(options);
      return this.options.post(this.url(ctx.queryOptions.assetType, ctx.id) + "?op=Delete");
    };

    RestPersister.prototype.create = function(ctx, options) {
      var asset, attr, attrXml, toAttribute, toSingleRelation;
      if (!isModel(ctx.constructor)) {
        throw "Unsupported context";
      }
      options = options || {};
      attr = options.attrs || ctx.toJSON(options);
      toAttribute = function(attribute, alias) {
        var value;
        value = attr[alias];
        if (value == null) {
          return;
        }
        return "<Attribute name=\"" + (_.escape(attribute)) + "\" act=\"set\">" + (_.escape(attr[alias])) + "</Attribute>";
      };
      toSingleRelation = function(relation) {
        var oid, value;
        value = attr[relation.alias];
        if (value == null) {
          return;
        }
        oid = value.id;
        return "<Relation name=\"" + (_.escape(relation.attribute)) + "\" act=\"set\"><Asset idref=\"" + (_.escape(oid)) + "\" /></Relation>";
      };
      attrXml = _(ctx.queryOptions.schema).chain().map(function(item) {
        if (item instanceof Relation && item.isSingle()) {
          return toSingleRelation(item);
        }
        if (item instanceof Relation) {
          return;
        }
        if (item instanceof Alias) {
          return toAttribute(item.attribute, item.alias);
        }
        if (_.isString(item)) {
          return toAttribute(item, item);
        }
      }).value().join("");
      asset = "<Asset>" + attrXml + "</Asset>";
      return this.options.post(this.url(ctx.queryOptions.assetType, ctx.id), asset).done(function(data) {
        var result;
        if (result = /id="(\w+:\d+):\d+"/.exec(data)) {
          return ctx.id = result[1];
        }
      });
    };

    return RestPersister;

  })();


  /* Relation Helpers */

  aug = function(target, action) {
    var Dup;
    Dup = function() {};
    Dup.prototype = target;
    return _(new Dup()).tap(action || function() {});
  };

  aug.extend = function(target, props) {
    return aug(target, function(augmentedResult) {
      return _.extend(augmentedResult, props);
    });
  };

  aug.add = function(target, property, values) {
    return aug(target, function(augmentedResult) {
      return augmentedResult[property] = _.isArray(target[property]) ? target[property].concat(values) : values;
    });
  };

  aug.merge = function(target, props) {
    return aug(target, function(augmentedResult) {
      return _(props).each(function(val, key) {
        return target[key] = _.extend(val, target[key]);
      });
    });
  };

  Alias = (function() {
    function Alias(attribute) {
      this.attribute = attribute;
      this.alias = this.attribute;
    }

    Alias.prototype.as = function(alias) {
      return aug.extend(this, {
        alias: alias
      });
    };

    return Alias;

  })();

  V1.Backbone.alias = function(attribute) {
    return new Alias(attribute);
  };

  Relation = (function(_super) {
    __extends(Relation, _super);

    function Relation(attribute) {
      this.attribute = attribute;
      Relation.__super__.constructor.call(this, this.attribute);
      this.type = V1.Backbone.Collection;
    }

    Relation.prototype.isMulti = function() {
      return isCollection(this.type);
    };

    Relation.prototype.isSingle = function() {
      return isModel(this.type);
    };

    Relation.prototype.of = function(type) {
      if (!isAcceptable(type)) {
        throw "Unsupported type must be a V1.Backbone.Model or a V1.Backbone.Collection";
      }
      return aug.extend(this, {
        type: type
      });
    };

    Relation.prototype.addFilter = function() {
      var filters;
      filters = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return aug.add(this, "filter", filters);
    };

    Relation.prototype.addWhere = function(where) {
      return aug.merge(this, {
        where: where
      });
    };

    Relation.prototype.addWith = function(newWith) {
      return aug.merge(this, {
        newWith: newWith
      });
    };

    return Relation;

  })(Alias);

  V1.Backbone.relation = function(attribute) {
    return new Relation(attribute);
  };

}).call(this);
