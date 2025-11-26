require 'rails_helper'

RSpec.describe 'Spell' do
  before(:each) do
    @spell1 = Spell.new({name: "Firebolt", element: "fire", mana_cost: 10})
  end

  it 'has attributes' do
    expect(@spell1.name).to eq("Firebolt")
    expect(@spell1.element).to eq("fire")
    expect(@spell1.mana_cost).to eq(10)
  end
end
