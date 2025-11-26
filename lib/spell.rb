class Spell
  attr_reader :name, :element, :mana_cost
  
  def initialize(data)
    @name      = data[:name]
    @element   = data[:element]
    @mana_cost = data[:mana_cost]
  end
end
