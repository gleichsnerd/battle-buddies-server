class Turn

  # Valid actions:
  # :wait
  # :move
  # :attack
  # :defend
  @p_action

  # Valid directions:
  # :none
  # :up
  # :down
  # :left
  # :right
  @direction

  attr_accessor :p_action, :direction, :player

  def initialize(p_action = :wait, direction = :none, player)
    @p_action = p_action
    @direction = direction
    @player = player
  end

  def self.opposite_direction(direction)
    case direction
    when :up
      :down
    when :down
      :up
    when :left
      :right
    when :right
      :left
    else 
      :none
    end
  end

end