require 'rails_helper'

RSpec.describe 'Wizard' do
  before(:each) do
    @spell1 = Spell.new({name: "Firebolt", element: "fire", mana_cost: 10})
    @spell2 = Spell.new({name: "Ice Shield", element: "water", mana_cost: 5})
    @spell3 = Spell.new({name: "Lightning Strike", element: "air", mana_cost: 12})

    @wizard = Wizard.new("Gandalf", 20)
  end

  it 'has attributes' do
    expect(@wizard.name).to eq("Gandalf")
    expect(@wizard.level).to eq(20)
    expect(@wizard.prepared_spells).to eq({})
  end

  it '#known_spell?' do 
    expect(@wizard.known_spell?(@spell1)).to eq(false)
  
    @wizard.prepare_spell(@spell1, 2)

    expect(@wizard.known_spell?(@spell1)).to eq(true)
  end

  it '#prepare_spell accumulates prepared_spells' do 
    @wizard.prepare_spell(@spell1, 2)
    @wizard.prepare_spell(@spell1, 3)
    @wizard.prepare_spell(@spell2, 4)

    expect(@wizard.prepared_spells).to eq({
      @spell1 => 5,
      @spell2 => 4
    })
  end

  it '#knows_required_spells?' do 
    quest1 = Quest.new("Defeat the Dragon")
    quest2 = Quest.new("Storm the Castle")

    quest1.add_spell(@spell1, 2)
    quest1.add_spell(@spell2, 4)
    quest2.add_spell(@spell1, 1)
    quest2.add_spell(@spell3, 3)

    @wizard.prepare_spell(@spell1, 1)
    @wizard.prepare_spell(@spell2, 2)

    expect(@wizard.knows_required_spells?(quest1)).to eq(false)

    @wizard.prepare_spell(@spell1, 1)
    @wizard.prepare_spell(@spell2, 2)

    expect(@wizard.knows_required_spells?(quest1)).to eq(true)
    expect(@wizard.knows_required_spells?(quest2)).to eq(false)

    @wizard.prepare_spell(@spell3, 3)

    expect(@wizard.knows_required_spells?(quest2)).to eq(true)
  end
end
