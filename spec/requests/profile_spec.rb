require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { User.create!(email: "test3@example.com", password: "password") }

  before do
    sign_in user
  end

  it "returns http success" do
    get new_profile_path
    expect(response).to have_http_status(:success)
  end
end