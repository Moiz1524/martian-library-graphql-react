module Mutations
  class UpdateItemMutation < BaseMutation
    field :item, Types::ItemType, null: true
    field :errors, [String], null: false

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :image_url, String, required: false

    def resolve(id:, **attrs)
      if context[:current_user].nil?
        raise GraphQL::ExecutionError,
          'You need to authenticate to perform this action'
      end

      item = Item.find_by(id: id)

      if item.update!(attrs)
        { item: item }
      else
        { errors: item.errors.full_messages.join(',') }
      end
    end
  end
end