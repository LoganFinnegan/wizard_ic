require 'date'

class Guild
  attr_reader :quests
  
  def initialize
    @quests  = []
    @founded = Date.today
  end

  def add_quest(quest)
    @quests << quest
  end

  def spells
    quests.flat_map { |q| q.spells_required.keys.map(&:name) }.uniq
  end

  def hardest_quest
    quests.max_by { |q| q.total_mana_cost }
  end

  def date
    @founded.strftime("%m-%d-%Y")
  end

  def summary
    quests.map do |quest|
      sorted_spells = quest.spells_required.sort_by { |spell, casts| -(spell.mana_cost * casts) }

      {
        name: quest.name,
        details: {
          spells: sorted_spells.map { |spell, casts| { spell: spell.name, amount: "#{casts} casts" } },
          total_mana_cost: quest.total_mana_cost
        }
      }
    end
  end
end
