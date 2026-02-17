require "rails_helper"

RSpec.describe "CalorieRecords", type: :request do
  let(:user) { User.create!(email: "test2@example.com", password: "password") }

  before do
    Rails.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = Logger.new(STDOUT)
     # これが動いてない
     sign_in user
    end


  it "カロリー記録を作成する" do
    expect {
      post calorie_records_path, params: {
        calorie_record: {
          calorie: 500,
          meal_type: "breakfast",
          memo: "test"
        }
      }
    }.to change(CalorieRecord, :count).by(1)

    expect(response).to redirect_to(user_root_path)
  end
end
