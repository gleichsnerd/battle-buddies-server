require 'securerandom'
require './destructible_object'
require './turn'
require './event'

class Player < DestructibleObject

  attr_accessor :id, :type, :dmg, :defence, :hp, :name, :pos

  def initialize(name, dmg = 1, defence = 0, hp = 4)
    super(:player, hp, defence)

    @id=SecureRandom.uuid
    @dmg = dmg
    @name = name

    @turns = Array.new
  end

  def attack(target, direction)
    target.attacked(self, direction)
  end

  def miss(direction)
    description = "You swung #{direction} but missed." 
    Event.new(false, description, :attack, direction)
  end

  def attacked(player, direction)
    dmg = player.dmg
    attacking_self = player.id == @id
    blocked = can_block_attack_from(direction)

    defender_success = false
    attacker_success = false

    if blocked
      defender_success = true

      defender_success = "You blocked an attack!"
      attacker_description = "The attack was blocked."
    else
      attacker_success = true

      if attacking_self
        attacker_description = "You attacked yourself for #{dmg} damage. You feel betrayed."
      else
        defender_success = "You were attacked by a player for #{dmg} damage."
        attacker_description = "You swung and hit the player."
      end

      @hp -= dmg - @defence
    end

    if is_dead?
      if attacking_self
        attacker_description = attacker_description + " Oh, and you killed yourself."
      else
        defender_success = defender_success + " You are dead!"
        attacker_description = attacker_description + " The player is dead!"
      end
    end

    attacker_event = Event.new(attacker_success, attacker_description, :attack, direction)
    defender_event = attacking_self ? nil : Event.new(defender_success, defender_description, :attacked, Turn.opposite_direction(direction))

    {
      :attacker => attacker_event,
      :defender => defender_event
    }

  end

  def block(direction)
    @block_side = direction
    if direction == :none
      description = "You contemplate lifting your shield, but decide against it."
    else
      description = "You hold your shield #{direction}."
    end

    Event.new(true, description, :defend, direction)
  end

  def can_block_attack_from(direction)
    @block_side != :none && Turn.opposite_direction(direction) == @block_side
  end

  def unblock
    @block_side = :none
  end

  def wait
    Event.new(true, "You decide to wait and see how this turn plays out.", :wait, :none)
  end

  def to_h_public
    {
      :type => :player,
      :name => @name
    }
  end

  def to_h
    {
      :type => :player,
      :id => @id,
      :name => @name,
      :hp => @hp,
      :dmg => @dmg,
      :defence => @defence,
      :pos => @pos,
      :turns => @turns.map { |turn| turn.to_h }
    }
  end

end