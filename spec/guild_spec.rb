require 'rails_helper'
require 'date'

RSpec.describe 'Guild' do
  before(:each) do
    @spell1 = Spell.new({name: "Firebolt", element: "fire", mana_cost: 10})
    @spell2 = Spell.new({name: "Ice Shield", element: "water", mana_cost: 5})
    @spell3 = Spell.new({name: "Lightning Strike", element: "air", mana_cost: 12})

    @quest1 = Quest.new("Defeat the Dragon")
    @quest2 = Quest.new("Protect the Village")

    @guild   = Guild.new
  end

  it 'has attributes' do 
    expect(@guild.quests).to eq([])
  end

  it '#add_quest' do
    @guild.add_quest(@quest1)
    @guild.add_quest(@quest2)

    expect(@guild.quests).to eq([@quest1, @quest2])
  end

  it '#spells' do 
    @guild.add_quest(@quest1)
    @guild.add_quest(@quest2)

    @quest1.add_spell(@spell1, 2)
    @quest1.add_spell(@spell2, 4)
    @quest2.add_spell(@spell1, 1)
    @quest2.add_spell(@spell3, 3)

    expect(@guild.spells).to eq(["Firebolt", "Ice Shield", "Lightning Strike"])
  end

  it '#hardest_quest' do
    @guild.add_quest(@quest1)
    @guild.add_quest(@quest2)

    @quest1.add_spell(@spell1, 2)
    @quest1.add_spell(@spell2, 4)
    @quest2.add_spell(@spell1, 1)
    @quest2.add_spell(@spell3, 3)

    expect(@guild.hardest_quest).to eq(@quest2)
  end

  it '#date' do 
    allow(Date).to receive(:today).and_return(Date.new(2020, 4, 22))
    guild = Guild.new

    expect(guild.date).to eq("04-22-2020")
  end

  it '#summary' do 
    spell4 = Spell.new({name: "Stone Skin", element: "earth", mana_cost: 2})

    @quest1.add_spell(@spell1, 2)
    @quest1.add_spell(@spell2, 4)
    @quest2.add_spell(@spell3, 3)
    @quest2.add_spell(spell4, 10)

    @guild.add_quest(@quest1)
    @guild.add_quest(@quest2)

    expect(@guild.summary).to eq([
      {
        name: "Defeat the Dragon",
        details: {
          spells: [
            {spell: "Firebolt", amount: "2 casts"},
            {spell: "Ice Shield", amount: "4 casts"}
          ],
          total_mana_cost: 40
        }
      },
      {
        name: "Protect the Village",
        details: {
          spells: [
            {spell: "Lightning Strike", amount: "3 casts"},
            {spell: "Stone Skin", amount: "10 casts"}
          ],
          total_mana_cost: 56
        }
      }
    ])
  end
end
