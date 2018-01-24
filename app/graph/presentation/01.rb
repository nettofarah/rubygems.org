# Simple Rubygem type
RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"
  description "a package of ruby code with specific functionality"

  # Name cannot be null
  field :name, !types.String
  # Downloads can be null
  field :downloads, types.Int
end

#########

# This is how we query it
QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :rubygems do
    # An array of the type RubygemType
    type types[RubygemType]

    # a lambda that allows us to describe
    # how to query our data
    resolve -> (_obj, _args, _ctx) {
      Rubygem.all
    }
  end
end
