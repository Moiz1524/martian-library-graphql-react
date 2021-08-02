require "rails_helper"

RSpec.describe Mutations::UpdateItemMutation do
  context "fields" do
    it "should have registered item" do
      expect(described_class).to have_a_field(:item).of_type(Types::ItemType)
    end

    it "should have registered errors" do
      expect(described_class).to have_a_field(:errors).of_type('[String!]!') 
    end
  end

  context "arguments" do
    it "should have registered id" do
      expect(described_class).to accept_argument(:id).of_type('ID!')
    end
    
    it "should have registered title" do
      expect(described_class).to accept_argument(:title).of_type('String')
    end

    it "should have registered description" do
      expect(described_class).to accept_argument(:description).of_type('String')  
    end

    it "should have registered image_url" do
      expect(described_class).to accept_argument(:image_url).of_type('String')  
    end
  end

  context ".resolve" do
    let(:user) { create(:user, first_name: 'Moiz', last_name: 'Ali') }
    let(:item) { create(:item, title: 'Test Item') }
    
    let(:mutation) do
      %(mutation {
        updateItem(
          id: "#{item.id}"
          title: "Test Item edited",
        ){
          item {
            id
            title
          }
        }
      })
    end

    subject(:result) do
      MartianLibrarySchema.execute(mutation, context: { current_user: user })      
    end

    subject(:bad_result) do
      MartianLibrarySchema.execute(mutation, context: { current_user: nil })
    end

    it "should resolve the mutation and return response" do
      expect(result.dig("data", "updateItem", "item", "title")).to eq("Test Item edited")  
    end

    it "should test resolver response when current_user is nil" do
      expect(bad_result.to_h.dig('errors')[0]["message"]).to eq("You need to authenticate to perform this action")
    end    

  end
  
end
