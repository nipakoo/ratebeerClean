require 'rails_helper'

include OwnTestHelper

BeerClubsController
MembershipsController

describe "User" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }

  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "favorite style shown" do
    user = User.first
    FactoryGirl.create(:rating, score:25, beer:beer1, user:user)

    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create(:rating, score:25, beer:beer1, user:user)

    visit user_path(user)

    expect(page).to have_content 'Favorite style: Lager'
    expect(page).to have_content 'Favorite brewery: Koff'
  end
end