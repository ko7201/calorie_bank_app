require 'rails_helper'

RSpec.describe "Homes", type: :request do
  let(:user) { User.create!(email: "test2@example.com", password: "password") }

  before do
    user.create_profile!(
      age: 30,
      height: 170,
      weight: 60,
      activity_level: :low,
      weight_to_lose: 3,
      gender: :male,
      target_saving_calories: 300,
      rice_gram: 150
    )
    sign_in user
  end

  it "returns http success" do
    get homes_path
    expect(response).to have_http_status(:success)
  end
end
