require './game_object'

class DestructibleObject < GameObject

  attr_accessor :hp, :defence

  def initialize(type = :destructible, hp, defence)
    super(type)
    @hp = hp
    @defence = defence
  end

  def attacked(player, direction)
    dmg = player.dmg
    return_event = "You attacked the thing."

    @hp -= dmg - @defence

    if is_dead?
      return_event = return_event + " It broke!"
    end

    return_event
  end

  def is_dead?
    @hp <= 0
  end

end