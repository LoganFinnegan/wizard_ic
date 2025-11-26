require 'rails_helper'

RSpec.describe 'Quest' do
  before(:each) do
    @spell1 = Spell.new({name: "Firebolt", element: "fire", mana_cost: 10})
    @spell2 = Spell.new({name: "Ice Shield", element: "water", mana_cost: 5})
    @spell3 = Spell.new({name: "Lightning Strike", element: "air", mana_cost: 12})
    
    @wizard = Wizard.new("Gandalf", 20)

    @quest1 = Quest.new("Defeat the Dragon")
    @quest2 = Quest.new("Storm the Castle")
  end

  it 'has attributes' do
    expect(@quest1.name).to eq("Defeat the Dragon")
    expect(@quest1.spells_required).to eq({})
    
  end

  it '#add_spell' do 
    @quest1.add_spell(@spell1, 2)
    @quest1.add_spell(@spell1, 3)
    @quest1.add_spell(@spell2, 4)

    expect(@quest1.spells_required).to eq({
      @spell1 => 5, 
      @spell2 => 4
    })
  end

  it '#spells' do
    @quest1.add_spell(@spell1, 2)
    @quest1.add_spell(@spell2, 4)

    expect(@quest1.spells).to eq([@spell1, @spell2])
  end

  it '#total_mana_cost' do 
    @quest1.add_spell(@spell1, 2)
    @quest1.add_spell(@spell2, 4)

    expect(@quest1.total_mana_cost).to eq(40)
    
    @quest2.add_spell(@spell1, 1)
    @quest2.add_spell(@spell3, 3)

    expect(@quest2.total_mana_cost).to eq(46)
  end
end
