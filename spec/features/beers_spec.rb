require 'rails_helper'

describe "Beer" do

  it "is added with a valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'Kalja')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "is not added with an invalid name" do
    visit new_beer_path

    click_button('Create Beer')

    expect(current_path).to eq(beers_path)
    expect(Beer.count).to eq(0)
    expect(page).to have_content 'Name can\'t be blank'
  end
end