require 'rails_helper'

RSpec.describe "Devise::Passwords", type: :request do
  describe "GET /users/password/new" do
    it "正確にレスポンスが返ってくる" do
      get new_user_password_path
      expect(response).to have_http_status(200)
    end
  end
end
