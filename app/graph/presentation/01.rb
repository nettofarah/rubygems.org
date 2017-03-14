# Simple Rubygem type
RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"
  description "a package of ruby code with specific functionality"

  field :name, !types.String
  field :downloads, types.Int
end

#########

# This is how we query it
QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :rubygems do
    type types[RubygemType]

    resolve -> (obj, args, ctx) {
      Rubygem.all
    }
  end
end
