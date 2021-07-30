require "rails_helper"

RSpec.describe Mutations::AddItemMutation do
  context "fields" do
    it "should have registered title" do
      expect(described_class).to have_a_field(:item).of_type(Types::ItemType)
    end
    
    it "should have registered errors" do
      expect(described_class).to have_a_field(:errors).of_type('[String!]!')
    end
  end

  context "arguments" do
    it "should have registered title" do
      expect(described_class).to accept_argument(:title).of_type('String!')
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
    
    let(:mutation) do
      %(mutation {
        addItem(
          title: "Guitar Strings",
          description: "Daddario Gold",
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=d"
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
      expect(result.dig("data", "addItem", "item", "title")).to eq("Guitar Strings")
      expect(result.dig("data", "addItem", "item", "id")).not_to be_nil
    end

    it "should detach current_user and test resolver response" do
      # expect{ bad_result.dig("errors") }.match_array
    end
    
  end
end