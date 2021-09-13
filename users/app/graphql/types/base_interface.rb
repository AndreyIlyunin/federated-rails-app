module Types
  module BaseInterface
    include GraphQL::Schema::Interface
    include ApolloFederation::Interface
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)

    field_class Types::BaseField
  end
end
