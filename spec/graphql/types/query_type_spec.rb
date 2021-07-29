require "rails_helper"

RSpec.describe Types::QueryType do
  context "items" do
    let!(:items) { create_pair(:item) }

    let(:query) do
      %(query {
        items {
          title
        }
      })
    end

    subject(:result) do
      MartianLibrarySchema.execute(query).as_json
    end

    it "returns all items" do
      expect(result.dig("data", "items")).to match_array(items.map { |item| { "title" => item.title } })
    end
  end

  context "me" do
    let(:user) { create(:user) }

    let(:query) do
      %(query {
        me {
          email
        }
      })
    end

    subject(:result) do
      MartianLibrarySchema.execute(query, context: { current_user: user }).as_json
    end

    it "should return the current user" do
      expect(result.dig("data", "me", "email")).to eq(user.email)
    end
  end
end