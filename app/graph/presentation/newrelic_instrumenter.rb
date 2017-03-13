# NewRelic instrumenter for GraphQL-ruby
#
# In your controller:
#  ::NewRelic::Agent.add_custom_attributes({
#    user_id: @user.try(:id),
#    query_string: @query_string,
#    query_arguments: @query_variables
#  })
#
#   @document = self.class.trace_execution_scoped(["GraphQL#parse"]) do
#     GraphQL.parse(@query_string)
#   end
#
#   NewrelicInstrumenter::instrument_document(@document)
#
#
# In your GraphQL schema file
#  instrument(:field, NewrelicInstrumenter.new)

class NewrelicInstrumenter
  extend ::NewRelic::Agent::MethodTracer

  def instrument(type, field)
    old_resolve_proc = field.resolve_proc

    new_resolve_proc = ->(obj, args, ctx) {
      self.class.trace_execution_scoped(["GraphQL/field/#{type.name}.#{field.name}"]) do
        old_resolve_proc.call(obj, args, ctx)
      end
    }

    field.redefine do
      resolve(new_resolve_proc)
    end
  end

  # Instruments the top level query names from a controller
  # Only supports single definitions for now
  #
  def self.instrument_document(document)
    definition_name = document.definitions.first.name
    action_name = definition_name || definition_from_query(document)
    transaction_name = "GraphQL/#{action_name}"
    NewRelic::Agent.set_transaction_name(transaction_name)

    transaction_name
  end

  private

  def self.definition_from_query(document)
    query_definition = document.definitions.first

    top_level_selections = query_definition.selections.map do |selection|
      if selection.alias.present?
        "#{selection.alias}:#{selection.name}"
      else
        selection.name
      end
    end

    top_level_selections.join(',')
  end
end
