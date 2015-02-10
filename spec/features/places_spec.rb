require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [ Place.new( name:"Oljenkorsi", id: 1 ) ]
                             )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("vantaa").and_return(
                                 [ Place.new( name:"Joku", id: 1 ),
                                   Place.new( name:"Paikka", id: 2 ),
                                   Place.new( name:"Taalla", id: 3 ) ]
                             )

    visit places_path
    fill_in('city', with: 'vantaa')
    click_button "Search"

    expect(page).to have_content "Joku"
    expect(page).to have_content "Paikka"
    expect(page).to have_content "Taalla"
  end

  it "if many are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("orimattila").and_return(
                                 []
                             )

    visit places_path
    fill_in('city', with: 'orimattila')
    click_button "Search"

    expect(page).to have_content "No locations in orimattila"
  end
end