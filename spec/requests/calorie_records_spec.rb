require "rails_helper"

RSpec.describe "CalorieRecords", type: :request do
  let(:user) { User.create!(email: "test2@example.com", password: "password") }

  before do
    sign_in user
  end

  it "同じ日・同じ meal_type は初回は作成、2回目は上書き更新される" do
    # 1回目：作成される
    expect {
      post calorie_records_path, params: {
        calorie_record: {
          meal_type: "breakfast",
          base_calorie: 500,
          rice_bowls: 0,
          memo: "test"
        }
      }
    }.to change(CalorieRecord, :count).by(1)

    expect(response).to redirect_to(user_root_path)

    record = user.calorie_records.find_by!(eat_date: Date.current, meal_type: :breakfast)
    expect(record.base_calorie).to eq(500)
    expect(record.memo).to eq("test")

    # 2回目：件数は増えず、同じレコードが更新される
    expect {
      post calorie_records_path, params: {
        calorie_record: {
          meal_type: "breakfast",
          base_calorie: 600,
          rice_bowls: 1,
          memo: "updated"
        }
      }
    }.not_to change(CalorieRecord, :count)

    expect(response).to redirect_to(user_root_path)

    record.reload
    expect(record.base_calorie).to eq(600)
    expect(record.rice_bowls).to eq(1)
    expect(record.memo).to eq("updated")
  end
end