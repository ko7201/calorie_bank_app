require 'rails_helper'

RSpec.describe "Devise::Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "正確にレスポンスが返ってくる" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end
end