require 'rails_helper'

RSpec.describe "ログイン", type: :system do
  let!(:user) { User.create!(email: "test@example.com", password: "password") }

  before do
    user.create_profile!(
      age: 30, height: 170, weight: 60,
      activity_level: :low, weight_to_lose: 3,
      gender: :male, target_saving_calories: 300, rice_gram: 150
    )
  end

  it "正しいメールアドレスとパスワードでログインできる" do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_content("過去の記録を見る")
  end
end