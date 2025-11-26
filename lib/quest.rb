class Quest
  attr_reader :name, :spells_required
  
  def initialize(name)
    @name            = name
    @spells_required = Hash.new(0)
  end

  def add_spell(spell, amount)
    spells_required[spell] += amount
  end

  def spells
    spells_required.keys
  end

  def total_mana_cost
    spells_required.sum do |mana_cost, casts_required|
      mana_cost.mana_cost * casts_required
    end
  end
end