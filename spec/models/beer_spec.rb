require 'rails_helper'

describe Beer do
  it "is saved with proper name and style" do
    beer = Beer.create name:"Vehna", style:"Lager"

    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Lager"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Vehna"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
