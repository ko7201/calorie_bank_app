require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "正確にレスポンスが返ってくる" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /terms" do
    it "正確にレスポンスが返ってくる" do
      get terms_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /privacy" do
    it "正確にレスポンスが返ってくる" do
      get privacy_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /about" do
    it "正確にレスポンスが返ってくる" do
      get about_path
      expect(response).to have_http_status(200)
    end
  end
end
