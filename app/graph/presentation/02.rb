# Now we'll add an argument to the query
QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :rubygem_by_name do
    type RubygemType
    argument :name, !types.String

    resolve -> (obj, args, ctx) {
      name = args[:name]
      Rubygem.find_by(name: name)
    }
  end

  # ...
end
