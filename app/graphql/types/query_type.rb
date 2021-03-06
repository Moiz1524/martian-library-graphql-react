module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    # field :test_field, String, null: false,
    #   description: "An example field added by the generator"
    # def test_field
    #   "Hello World!"
    # end

    field :items, [Types::ItemType], 
      null: false, 
      description: "Returns a list of items in martian library"

    field :me, Types::UserType, null: true

    def items
      # Item.all
      # To avoid N+1 query problems, eager load the user
      Item.preload(:user)
    end

    def me
      context[:current_user]
    end
  end
end
