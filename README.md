# Wizard Workshop IC

## Setup & Submission

1. Fork this repository.  
2. Clone your fork to your local machine.  
3. Complete the activity below using TDD.  
4. Push your solution to your fork.  
5. Submit a Pull Request from your repository to this repository.  
   - Include your name in the PR.

In order to earn points, methods must be tested appropriately and implemented per the interaction pattern.

### Suggested File Structure

```
lib/spell.rb
lib/wizard.rb
lib/quest.rb
lib/guild.rb

spec/spell_spec.rb
spec/wizard_spec.rb
spec/quest_spec.rb
spec/guild_spec.rb
```

---

## Iteration 1 – Spell and Wizard

There are 4 possible points in Iteration 1:

1. Spell creation (with all `attr_readers`)  
2. Wizard creation (with all `attr_readers`)  
3. `Wizard#known_spell?`  
4. `Wizard#prepare_spell`  

### Spell

A `Spell` has:

- `name` – String  
- `element` – String  
- `mana_cost` – Integer  

### Wizard

A `Wizard` has:

- `name` – String  
- `level` – Integer  
- `prepared_spells` – a Hash mapping Spell objects to the number of prepared casts  

A wizard “knows” a spell if they have ever prepared it at least once.  
Knowledge is inferred from `prepared_spells`.

---

### Iteration 1 Interaction Pattern

```ruby
require './lib/spell'
require './lib/wizard'

spell1 = Spell.new({ name: "Firebolt", element: "fire", mana_cost: 10 })
spell1.name
# => "Firebolt"
spell1.element
# => "fire"
spell1.mana_cost
# => 10

spell2 = Spell.new({ name: "Ice Shield", element: "water", mana_cost: 5 })

wizard = Wizard.new("Gandalf", 20)
wizard.prepared_spells
# => {}

wizard.known_spell?(spell1)
# => false

wizard.prepare_spell(spell1, 2)
wizard.known_spell?(spell1)
# => true

wizard.prepare_spell(spell1, 3)
wizard.prepare_spell(spell2, 4)

wizard.prepared_spells
# => {spell1 => 5, spell2 => 4}
```
### Iteration 1 Expectations

#### Spell

- Has `attr_readers` for:
  - `:name`
  - `:element`
  - `:mana_cost`

#### Wizard

- Has `attr_readers` for:
  - `:name`
  - `:level`
  - `:prepared_spells`
- `prepared_spells` starts as `{}`.

##### `Wizard#known_spell?(spell)`

- Returns `true` if the spell exists in `prepared_spells` with a count greater than 0.  
- Returns `false` otherwise.

##### `Wizard#prepare_spell(spell, times)`

- Adds the spell to `prepared_spells` if it is not already present.  
- Increments its count by `times`.

---

## Iteration 2 – Quest and Guild

There are 4 possible points in Iteration 2:

1. Quest and Guild creation (with all `attr_readers`)  
2. `Quest#add_spell`  
3. `Quest#spells`  
4. `Guild#add_quest`  

### Iteration 2 Expectations

#### Quest

A `Quest` has:

- `name` – String  
- `spells_required` – Hash mapping `Spell` objects to casts required  

##### `Quest#add_spell(spell, casts)`

- Adds the spell if it is not already in `spells_required`.  
- Increases the required casts for that spell by the given amount.

##### `Quest#spells`

- Returns an array of the `Spell` objects used in the quest.

#### Guild

A `Guild`:

- Has a `quests` array.  
- Starts empty.  
- Adds quests using `add_quest`.

---

### Iteration 2 Interaction Pattern
```ruby
require './lib/spell'
require './lib/quest'

spell1 = Spell.new({ name: "Firebolt", element: "fire", mana_cost: 10 })
spell2 = Spell.new({ name: "Ice Shield", element: "water", mana_cost: 5 })

quest1 = Quest.new("Defeat the Dragon")
quest1.spells_required
# => {}

quest1.add_spell(spell1, 2)
quest1.add_spell(spell1, 3)
quest1.add_spell(spell2, 4)

quest1.spells_required
# => {spell1 => 5, spell2 => 4}

quest1.spells
# => [spell1, spell2]

quest2 = Quest.new("Protect the Village")

require './lib/guild'
guild = Guild.new

guild.quests
# => []

guild.add_quest(quest1)
guild.add_quest(quest2)

guild.quests
# => [quest1, quest2]
```
### Iteration 2 Expectations

#### Quest

- Has `attr_readers` for:
  - `:name`
  - `:spells_required`
- `spells_required` starts as `{}`.
- `add_spell` adds or increments spells.
- `spells` returns the `Spell` objects used.

#### Guild

- Has `attr_reader` for `:quests`.
- `quests` starts as an empty array.
- `add_quest` appends a quest.

---

## Iteration 3 – Mana & Difficulty

There are 4 possible points in Iteration 3:

1. `Quest#total_mana_cost`  
2. `Guild#spells`  
3. `Guild#hardest_quest`  
4. `Wizard#knows_required_spells?`  

### Iteration 3 Behavior

#### `Quest#total_mana_cost`

- Sums `spell.mana_cost * casts_required` for each required spell.

#### `Guild#spells`

- Returns an array of unique spell names used across all quests, in the order they first appear.

#### `Guild#hardest_quest`

- Returns the quest with the highest total mana cost.

#### `Wizard#knows_required_spells?(quest)`

- Returns `true` if the wizard has enough prepared casts of every spell required by the quest.

---

### Iteration 3 Interaction Pattern
```ruby 
require './lib/spell'
require './lib/wizard'
require './lib/quest'
require './lib/guild'

spell1 = Spell.new({ name: "Firebolt", element: "fire", mana_cost: 10 })
spell2 = Spell.new({ name: "Ice Shield", element: "water", mana_cost: 5 })
spell3 = Spell.new({ name: "Lightning Strike", element: "air", mana_cost: 12 })

wizard = Wizard.new("Gandalf", 20)

quest1 = Quest.new("Defeat the Dragon")
quest1.add_spell(spell1, 2)
quest1.add_spell(spell2, 4)
quest1.total_mana_cost
# => 40

quest2 = Quest.new("Protect the Village")
quest2.add_spell(spell1, 1)
quest2.add_spell(spell3, 3)
quest2.total_mana_cost
# => 46

guild = Guild.new
guild.add_quest(quest1)
guild.add_quest(quest2)

guild.spells
# => ["Firebolt", "Ice Shield", "Lightning Strike"]

guild.hardest_quest
# => quest2

wizard.prepare_spell(spell1, 1)
wizard.prepare_spell(spell2, 2)
wizard.prepare_spell(spell3, 1)

wizard.knows_required_spells?(quest1)
# => false  # not enough Firebolt and Ice Shield prepared

wizard.prepare_spell(spell1, 1)
wizard.prepare_spell(spell2, 2)

wizard.knows_required_spells?(quest1)
# => true

wizard.knows_required_spells?(quest2)
# => false  # not enough Lightning Strike prepared

wizard.prepare_spell(spell3, 2)

wizard.knows_required_spells?(quest2)
# => true
```
### Iteration 3 Expectations

#### Quest

- `total_mana_cost`:
  - Iterates through `spells_required` and sums `spell.mana_cost * casts_required` for each entry.

#### Guild

- `spells`:
  - Returns an array of unique spell names used across all quests, in order of first appearance.
- `hardest_quest`:
  - Returns the quest instance with the highest `total_mana_cost`.

#### Wizard

- `knows_required_spells?(quest)`:
  - For each `(spell, casts_required)` in `quest.spells_required`, checks that:
    - `prepared_spells[spell]` (treat `nil` as `0`) is greater than or equal to `casts_required`.
  - Returns `true` only if this is true for all required spells.

---

## Iteration 4 – Guild Date & Summary

There are 2 possible points in Iteration 4:

1. `Guild#date`  
2. `Guild#summary`  

### Iteration 4 Behavior

#### `Guild#date`

- Stores the date when the `Guild` is created.  
- Returns it as a `String` in `"mm-dd-yyyy"` format.

#### `Guild#summary`

- Returns an array of hashes with information about each quest.  
- For each quest:
  - Spells are listed in order of mana contribution, where:
    - Contribution = `spell.mana_cost * casts_required`.

---

### Iteration 4 Interaction Pattern
```ruby 
require './lib/spell'
require './lib/quest'
require './lib/guild'

guild = Guild.new
guild.date
# => "04-22-2020"  # example; actual value depends on current date

spell1 = Spell.new({ name: "Firebolt", element: "fire", mana_cost: 10 })
spell2 = Spell.new({ name: "Ice Shield", element: "water", mana_cost: 5 })

quest1 = Quest.new("Defeat the Dragon")
quest1.add_spell(spell1, 2)
quest1.add_spell(spell2, 4)
# Firebolt contributes 20 mana (2 * 10)
# Ice Shield contributes 20 mana (4 * 5)

spell3 = Spell.new({ name: "Lightning Strike", element: "air", mana_cost: 12 })
spell4 = Spell.new({ name: "Stone Skin", element: "earth", mana_cost: 2 })

quest2 = Quest.new("Protect the Village")
quest2.add_spell(spell3, 3)
quest2.add_spell(spell4, 10)
# Lightning Strike contributes 36 mana (3 * 12)
# Stone Skin contributes 20 mana (10 * 2)

guild.add_quest(quest1)
guild.add_quest(quest2)

quest1.total_mana_cost
# => 40

quest2.total_mana_cost
# => 56

guild.summary
# => [
#      {
#        :name=>"Defeat the Dragon",
#        :details=>{
#          :spells=>[
#            {:spell=>"Firebolt", :amount=>"2 casts"},
#            {:spell=>"Ice Shield", :amount=>"4 casts"}
#          ],
#          :total_mana_cost=>40
#        }
#      },
#      {
#        :name=>"Protect the Village",
#        :details=>{
#          :spells=>[
#            {:spell=>"Lightning Strike", :amount=>"3 casts"},
#            {:spell=>"Stone Skin", :amount=>"10 casts"}
#          ],
#          :total_mana_cost=>56
#        }
#      }
#    ]
```
### Iteration 4 Expectations

#### `Guild#date`

- Stores the creation date when `Guild.new` is called.  
- Returns the date formatted as `"mm-dd-yyyy"`.

#### `Guild#summary`

- Returns an array of hashes.  
- Each hash represents a quest and has the structure:

  ```ruby
  {
    :name => "Quest Name",
    :details => {
      :spells => [
        { :spell => "Spell Name", :amount => "X casts" },
        # ...
      ],
      :total_mana_cost => 123
    }
  }
  
For each quest:

- `:name` is the quest name (`String`).

- `:details[:spells]` is an array of hashes for each spell:
  - `:spell` – spell name (`String`)
  - `:amount` – `String` in the format `"X casts"`
  - Spells are ordered by descending mana contribution (`mana_cost * casts_required`) for that quest.

- `:details[:total_mana_cost]` is the total mana cost for that quest (`Integer`).
