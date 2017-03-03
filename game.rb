require './board'
require './player'

class Game

  attr_reader :players

  def initialize(width, height, number_of_players)
    @board = Board.new(width, height, number_of_players)
    @players = Hash.new()
  end

  def add_player(player)
    @players[player.id] = player
    @board.put_in_starting_position(player)
  end

  def display(options = {})
    if options.size == 0
      {
        :board => @board.to_h
      }
    else
      p options
      player_id = options[:player_id]
      {
        :board => @board.to_h,
        :player => @players[player_id].to_h
      }
    end
  end

  def parse_turns(turns)
    p "Parsing turns"
    p turns

    turns.each do |turn|
      # p "Parsing turn: " + turn.player.id + " " + turn.p_action # + " " + turn.direction 
      case turn.p_action
        when :move
          "Player is moving"
          player_move(turn.player, turn.direction)
        else
          # TODO
      end
    end
  end


  def player_move(player, direction)
    @board.move(player, direction)
  end

  def player_attack(player, direction)
    
  end

end