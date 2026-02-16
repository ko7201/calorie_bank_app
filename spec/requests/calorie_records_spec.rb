require 'rails_helper'

RSpec.describe "CalorieRecords", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/calorie_records/create"
      expect(response).to have_http_status(:success)
    end
  end

end
