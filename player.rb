require 'securerandom'
require './destructible_object'

class Player < DestructibleObject

  attr_accessor :id, :type, :dmg, :defence, :hp, :events

  def initialize(dmg = 1, defence = 0, hp = 4)
    @id=SecureRandom.uuid
    @type=:player

    @dmg = dmg
    @defence = defence
    @hp = hp

    @events = Array.new
  end

  def attack(target)
    event = target.attacked(self)

    add_event(event)
  end

  def miss(direction)
    event = "You swung #{direction} but missed." 
    add_event(event)
  end

  def attacked(player)
    dmg = player.dmg
    attacking_self = player.id == @id

    if attacking_self
      return_event = "You attacked yourself for #{dmg} damage. You feel betrayed."
    else
      event = "You were attacked by a player for #{dmg} damage."
      return_event = "You swung and hit the player."
    end

    @hp -= dmg - @defence

    if is_dead?
      if attacking_self
        return_event = return_event + " Oh, and you killed yourself."
      else
        event = event + " You are dead!"
        return_event = return_event + " The player is dead!"
      end
    end

    if !attacking_self
      add_event(event)
    end

    return_event
  end

  def move(direction)
    event = "You moved #{direction}"

    add_event(event)
  end

  def to_h_public
    {
      :type => :player,
      :name => "Foo"
    }
  end

  def to_h
    {
      :type => :player,
      :id => @id,
      :name => "Foo",
      :pos => @pos,
      :hp => @hp,
      :dmg => @dmg,
      :defence => @defence,
      :events => @events
    }
  end

end