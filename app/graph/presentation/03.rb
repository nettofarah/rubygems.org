# Add more fields
RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"

  field :name, !types.String
  field :created_at, types.String

  # with custom resolve blocks
  field :versions do
    type types[VersionType]

    resolve -> (obj, args, ctx) {
      obj.versions
    }
  end

  field :latest_version, VersionType
  field :downloads, types.Int
end

# More types
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
