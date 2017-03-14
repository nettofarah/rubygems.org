require 'graphql/query_resolver'

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :rubygem do
    type RubygemType
    argument :name, !types.String

    resolve -> (obj, args, ctx) {
      name = args[:name]
      Rubygem.find_by(name: name)
    }
  end

  field :rubygems do
    type types[RubygemType]

    resolve -> (obj, args, ctx) {
      GraphQL::QueryResolver.run(Rubygem, ctx, RubygemType) do
        Rubygem.all
      end
    }
  end
end

RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"

  field :name, !types.String
  field :created_at, types.String

  field :versions do
    type types[VersionType]

    resolve -> (obj, args, ctx) {
      obj.versions
    }
  end

  field :latest_version, VersionType
  field :downloads, types.Int
end

VersionType = GraphQL::ObjectType.define do
  name "Version"
  description "a specific version of a rubygem"

  field :authors, types.String
  field :description, types.String
  field :number, types.String
  field :summary, types.String
  field :latest, types.Boolean

  field :downloads do
    type types.Int

    resolve -> (obj, args, ctx) {
      obj.downloads_count
    }
  end

  field :dependencies do
    type types[DependencyType]

    resolve -> (obj, args, ctx) {
      obj.dependencies
    }
  end
end

DependencyType = GraphQL::ObjectType.define do
  name "Dependency"
  description "a dependency for a specific version of a given Rubygem"

  field :requirements, types.String
  field :scope, types.String
  field :name, types.String

  field :rubygem, RubygemType
end
