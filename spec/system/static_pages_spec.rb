require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  it "トップページから利用規約ページに遷移できる" do
    visit root_path
    click_link "利用規約"
    expect(page).to have_content("利用規約")
  end

  it "トップページからプライバシーポリシーページに遷移できる" do
    visit root_path
    click_link "プライバシーポリシー"
    expect(page).to have_content("プライバシーポリシー")
  end

  #PC表示ページでのテスト
  it "トップページから初めての方へページに遷移できる" do
    visit root_path
    click_link "初めての方へ", visible: true
    expect(page).to have_content("初めての方へ")
  end

  it "仕組みを見るボタンを押すとモーダルが表示される" do
    visit root_path
    click_button "仕組みを見る"

    within("#mechanismModal") do
      expect(page).to have_content("貯金の計算")
    end
  end
end

