require 'securerandom'
require './destructible_object'
require './turn'

class Player < DestructibleObject

  attr_accessor :id, :type, :dmg, :defence, :hp, :events, :name

  def initialize(name, dmg = 1, defence = 0, hp = 4)
    @id=SecureRandom.uuid
    @type=:player

    @dmg = dmg
    @defence = defence
    @hp = hp
    @name = name

    @events = Array.new
  end

  def attack(target, direction)
    event = target.attacked(self, direction)

    add_event(event)
  end

  def miss(direction)
    event = "You swung #{direction} but missed." 
    add_event(event)
  end

  def attacked(player, direction)
    dmg = player.dmg
    attacking_self = player.id == @id
    blocked = can_block_attack_from(direction)

    if blocked
      event = "You blocked an attack!"
      return_event = "The attack was blocked."
    else
      if attacking_self
        return_event = "You attacked yourself for #{dmg} damage. You feel betrayed."
      else
        event = "You were attacked by a player for #{dmg} damage."
        return_event = "You swung and hit the player."
      end

      @hp -= dmg - @defence
    end

    if is_dead?
      if attacking_self
        return_event = return_event + " Oh, and you killed yourself."
      else
        event = event + " You are dead!"
        return_event = return_event + " The player is dead!"
      end
    end

    if blocked
      append_event(event)
    elsif !attacking_self
      add_event(event)
    end

    return_event
  end

  def block(direction)
    @block_side = direction
    if direction == :none
      add_event("You contemplate lifting your shield, but decide against it.")
    else
      add_event("You hold your shield #{direction}.")
    end
  end

  def can_block_attack_from(direction)
    @block_side != :none && Turn.opposite_direction(direction) == @block_side
  end

  def unblock
    @block_side = :none
  end

  def wait
    add_event("You decide to wait and see how this turn plays out.")
  end

  def move(direction)
    event = "You moved #{direction}"

    add_event(event)
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
      :events => @events
    }
  end

end