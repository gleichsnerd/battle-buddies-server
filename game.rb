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
      players = @players.select { |k, player| !player.is_dead? }.map { |k, player| player.to_h_public }
      deceased = @players.select { |k, player| player.is_dead? }.map { |k, player| player.to_h_public }

      {
        :board => @board.to_h,
        :players => players,
        :deceased => deceased
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
      p "Parsing turn"

      if !turn.player.is_dead?
        case turn.p_action
          when :move
            "Player is moving"
            player_move(turn.player, turn.direction)
          when :attack
            "Player is attacking"
            player_attack(turn.player, turn.direction)
          else
            # TODO
        end
      else
        turn.player.dead
      end
    end
  end


  def player_move(player, direction)
    @board.move(player, direction)
  end

  def player_attack(player, direction)
    obj = @board.get_object_relative_to_player(player, direction)

    if obj.nil?
      player.miss(direction)
    else
      player.attack(obj)
    end
  end

  def cleanup_corpses
    @players.each do |key, player|
      if player.is_dead?
        @board.remove_player(player)
      end
    end
  end

end