require "rails_helper"

RSpec.describe Mutations::SignInMutation do
  context "arguments" do
    it "should accept $email as argument" do
      expect(described_class).to accept_argument(:email).of_type('String!')
    end
  end

  context "fields" do
    it "should have registered token field" do
      expect(described_class).to have_a_field(:token).of_type('String')
    end

    it "should have registered user field" do
      expect(described_class).to have_a_field(:user).of_type(Types::UserType)
    end
  end

  context ".resolve" do
    let(:user) { create(:user, first_name: 'Moiz', last_name: 'Ali') }
    let(:mutation) do
      %(mutation SignMeIn {
        signIn(email: "#{user.email}") {
          token
          user {
            id
            fullName
          }
        }
      })
    end

    # let(:bad_mutation) do
    #   %(mutation SignMeIn {
    #     signIn(email: "bad@example.com") {
    #       token
    #       user {
    #         id
    #         fullName
    #       }
    #     }
    #   })
    # end

    subject(:result) do
      MartianLibrarySchema.execute(mutation).as_json
    end

    # subject(:bad_result) do
    #   MartianLibrarySchema.execute(bad_mutation).as_json
    # end

    # it "should verify the unhappy path" do
      # expect(bad_result["data"]).to raise("ActiveRecord::RecordNotFound: Couldn't find User")
    # end

    it "should resolve the mutation and return response" do
      expect(result.dig("data", "signIn", "token")).not_to be_empty
      expect(result.dig("data", "signIn", "user", "fullName"))
        .to eq("#{user.first_name} #{user.last_name}")
    end
    
  end
  
end