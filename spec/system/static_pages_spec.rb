require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  it "トップページから利用規約ページに遷移できる" do
    visit root_path
    click_link "利用規約"
    expect(page).to have_content("利用規約")
  end
end