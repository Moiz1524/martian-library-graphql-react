require "rails_helper"

RSpec.describe Types::MutationType do
  context "fields" do
    it "should have registered sign_in field" do
      expect(described_class).to have_a_field(:sign_in)  
    end
  end
end