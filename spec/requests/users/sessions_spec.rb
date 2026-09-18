require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "正確にレスポンスが返ってくる" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end


  describe "DELETE /users/sign_out" do
    let(:user) { User.create!(email: "test4@example.com", password: "password") }

    before do
      sign_in user
    end

    it "ログアウトできる" do
      delete destroy_user_session_path
      expect(response).to have_http_status(303)
    end
  end
end