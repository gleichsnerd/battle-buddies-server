require './player'

class Board
  attr_accessor :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @board = Array.new(width) {Array.new(height)}
    @players = Hash.new
  end

  def add_player(player)
    @players[player.id] = player
  end

end