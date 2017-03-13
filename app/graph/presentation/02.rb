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
      Rubygem.all
    }
  end
end

RubygemType = GraphQL::ObjectType.define do
  name "Rubygem"

  field :name, !types.String
  field :downloads, types.Int
end
