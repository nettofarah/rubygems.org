require 'graphql/query_resolver'

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema. Here's where we define all our top level queries."

  field :rubygems do
    type types[RubygemType]
    description "Loads a collection of all available rubygems"

    resolve -> (obj, args, ctx) {
      Rubygem.all
      # GraphQL::QueryResolver.run(Rubygem, ctx, RubygemType) do
      # end
    }
  end

  field :rubygem do
    type RubygemType
    description "Looks up a specific Rubygem by name"
    argument :name, !types.String

    resolve -> (obj, args, ctx) {
      name = args[:name]
      Rubygem.find_by(name: name)
    }
  end
end

RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"
  description "A package of ruby code with specific functionality"

  field :name, !types.String
  field :latest_version, VersionType, "The latest published version of this Rubygem"
  field :downloads, types.Int, "The number of downloads for this Rubygem"

  field :versions do
    type types[VersionType]
    description "All versions of this Rubygem ever published"

    resolve -> (obj, args, ctx) {
      obj.versions
    }
  end
end

VersionType = GraphQL::ObjectType.define do
  name "Version"
  description "A specific version of a Rubygem"

  field :authors, types.String
  field :description, types.String
  field :number, types.String, "The version number"
  field :summary, types.String
  field :latest, types.Boolean, "Is this the latest version of this Rubygem?"

  field :downloads do
    type types.Int
    description "The number of downloads for this specific Version"

    resolve -> (obj, args, ctx) {
      obj.downloads_count
    }
  end

  field :dependencies do
    type types[DependencyType]
    description "All gem dependencies in this specific Version"

    resolve -> (obj, args, ctx) {
      obj.dependencies
    }
  end
end

DependencyType = GraphQL::ObjectType.define do
  name "Dependency"
  description "A dependency for a specific version of a given Rubygem"

  field :requirements, types.String, "The version range used for this dependency"
  field :scope, types.String, "How is this dependency used"
  field :name, types.String, "Name of the Rubygem used as a dependency"
  field :rubygem, RubygemType, "A pointer to the actual Rubygem for this dependency"
end
