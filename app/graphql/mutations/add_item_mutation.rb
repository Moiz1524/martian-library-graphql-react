module Mutations
  class AddItemMutation < BaseMutation
    # TODO: define return fields
    
    # field :post, Types::PostType, null: false
    field :item, Types::ItemType, null: true
    field :errors, [String], null: false

    # TODO: define arguments
    # argument :name, String, required: true
    argument :title, String, required: true
    argument :description, String, required: false
    argument :image_url, String, required: false

    # TODO: define resolve method
    def resolve(title:, description: nil, image_url: nil)
      if context[:current_user].nil?
        raise GraphQL::ExecutionError,
          "You need to authenticate to perform this action"
      end

      item = Item.new({
        title: title,
        description: description,
        image_url: image_url,
        user: context[:current_user]
      })

      if item.save
        { item: item }
      else
        { errors: item.errors.full_messages.join(',') }
      end
    end
  end
end
