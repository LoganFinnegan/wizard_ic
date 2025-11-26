class Wizard
  attr_reader :name, :level, :prepared_spells
  
  def initialize(name, level)
    @name            = name
    @level           = level
    @prepared_spells = Hash.new(0)
  end

  def known_spell?(spell)
    prepared_spells.key?(spell)
  end

  def prepare_spell(spell, amount)
    prepared_spells[spell] += amount
  end

  def knows_required_spells?(quest)
    quest.spells_required.all? do |spell, required_casts|
      prepared_spells[spell] >= required_casts
    end
  end
end