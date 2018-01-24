RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"
  description "A package of ruby code with specific functionality"

  field :name, types.String
  field :downloads, types.Int, "The number of downloads for this Rubygem"

  # Complex type: an array of Versions
  field :versions, types[VersionType], "All versions ever published for this Rubygem"
end

VersionType = GraphQL::ObjectType.define do
  name "Version"
  description "A specific version of a Rubygem"

  field :authors, types.String, "Author list separated by comma"
  field :number, types.String, "The version number"
  field :dependencies, types[DependencyType], "All gem dependencies in this specific Version"

  field :downloads do
    type types.Int
    description "The number of downloads for this specific Version"

    resolve -> (version, args, ctx) {
      version.downloads_count
    }
  end
end

DependencyType = GraphQL::ObjectType.define do
  name "Dependency"
  description "A dependency for a specific version of a given Rubygem"

  field :name, types.String, "Name of the Rubygem used as a dependency"
  field :requirements, types.String, "The version range used for this dependency"
end

# And now to queries
QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema. Here's where we define all our top level queries."

  field :rubygems do
    type types[RubygemType]
    description "Loads a collection of all available rubygems"

    resolve -> (_, args, ctx) {
      # We're using ActiveRecord here.
      # this is where the operation goes

      Rubygem.all.order(:name)
      # I can customize this block any way that I can.
      # Think of this as "controllers" or entrypoints in your traditional API
      # Rubygem.all.order(:created_at)
    }
  end

  field :rubygem_by_name do
    type RubygemType
    description "Looks up a specific Rubygem by name"
    argument :name, !types.String

    resolve -> (_, args, ctx) {
      name = args[:name]
      Rubygem.find_by(name: name)
    }
  end
end
