require 'rails_helper'

include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "amount shown correctly on ratings page" do
    create_some_ratings

    visit ratings_path

    expect(page).to have_content 'iso 3 25'
    expect(page).to have_content 'iso 3 17'
    expect(page).to have_content 'Karhu 25'
    expect(page).to have_content 'Number of ratings: 3'
  end

  it "amount shown correctly on user page" do
    create_some_ratings

    visit user_path(user)

    expect(page).to have_content 'Has made 3 ratings'
    expect(page).to have_content 'iso 3 25'
    expect(page).to have_content 'iso 3 17'
    expect(page).to have_content 'Karhu 25'
  end

  it "delete removes the rating from database" do
    FactoryGirl.create(:rating, score:25, beer:beer1, user:user)

    visit user_path(user)

    expect{
      click_link("delete")
    }.to change{Rating.count}.from(1).to(0)

  end
end

def create_some_ratings
  FactoryGirl.create(:rating, score:25, beer:beer1, user:user)
  FactoryGirl.create(:rating, score:17, beer:beer1, user:user)
  FactoryGirl.create(:rating, score:25, beer:beer2, user:user)
end