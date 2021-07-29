require 'rails_helper'

RSpec.describe "Libraries", type: :request do
  # GET /libraries # Root page of app
  it "should respond with a status of 200" do
    get root_path
    expect(response).to have_http_status(200)
  end
end
