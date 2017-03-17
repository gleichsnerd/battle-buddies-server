require './player'
require './indestructible_object'

class Board
  attr_reader :width, :height, :positions

  def initialize(width, height, number_of_players)
    @width = width
    @height = height
    @number_of_players = number_of_players
    @board = Array.new(width) {Array.new(height)}
    @starting_positions = create_starting_positions
    @positions = Hash.new
  end

  def create_starting_positions
    starts = Array.new

    if @number_of_players == 4
      starts.push( {:x => 0, :y => 0} )
      starts.push( {:x => @width - 1, :y => 0} )
      starts.push( {:x => @width - 1, :y => @height - 1} )
      starts.push( {:x => 0, :y => @height - 1} )
    end

    starts
  end

  def put_in_starting_position(player)
    pos = @starting_positions.shift

    @board[pos[:x]][pos[:y]] = player
    @positions[player.id] = pos
  end

  def to_h
    {
      :type => 'board',
      :grid => hash_board,
      :max_players => @number_of_players
    }
  end

  def hash_board
    h_board = Array.new()

    @board.each_with_index do |row, x|
      h_row = Array.new()
      row.each_with_index do |element, y|
        if element.nil?
          h_row.insert(y, nil)
        else
          h_row.insert(y, element.to_h_public)
        end
      end
      h_board.insert(x, h_row)
    end

    h_board
  end

  def move(player, direction)
    cur_pos = @positions[player.id]
    cur_x = cur_pos[:x]
    cur_y = cur_pos[:y]
    new_x = cur_x
    new_y = cur_y

    result = Hash.new   

    case direction
      when :up
        if cur_y != 0 && is_accessible(cur_x, cur_y - 1)
          new_y = cur_y - 1
        end
      when :down
        if cur_y != @height - 1 && is_accessible(cur_x, cur_y + 1)
          new_y = cur_y + 1
        end
      when :left
        if cur_x != 0 && is_accessible(cur_x - 1, cur_y)
          new_x = cur_x - 1
        end
      when :right
        if cur_x != @width - 1 && is_accessible(cur_x + 1, cur_y)
          new_x = cur_x + 1
        end
      else
        # Don't move
    end

    new_pos = {:x => new_x, :y => new_y}

    if new_pos == cur_pos
      result = { :success => false, :position => cur_pos }
    else
      clear_tile_at(cur_x, cur_y)
      put_player_at(player, new_x, new_y)
      @positions[player.id] = new_pos
      result = { :success => true, :position => new_pos }
    end

    result
  end

  def get_at(x, y)
    @board[x][y]
  end

  def get_object_relative_to_player(player, direction)
    cur_pos = @positions[player.id]
    cur_x = cur_pos[:x]
    cur_y = cur_pos[:y]

    obj = nil

    case direction
      when :up
        if cur_y == 0
          obj = IndestructibleObject.new
        elsif is_occupied(cur_x, cur_y - 1)
          obj = get_at(cur_x, cur_y - 1)
        end
      when :down
        if cur_y == @height - 1
          obj = IndestructibleObject.new
        elsif is_occupied(cur_x, cur_y + 1)
          obj = get_at(cur_x, cur_y + 1)
        end
      when :left
        if cur_x == 0
          obj = IndestructibleObject.new
        elsif is_occupied(cur_x - 1, cur_y)
          obj = get_at(cur_x - 1, cur_y)
        end
      when :right
        if cur_x == @width - 1
          obj = IndestructibleObject.new
        elsif is_occupied(cur_x + 1, cur_y)
          obj = get_at(cur_x + 1, cur_y)
        end
      else
        obj = player
    end

    obj

  end

  def clear_tile_at(x, y)
    @board[x][y] = nil
  end

  def put_player_at(player, x, y)
    @board[x][y] = player
    player.pos = {:x => x, :y => y}
  end

  def remove_player(player)
    cur_pos = @positions[player.id]
    clear_tile_at(cur_pos[:x], cur_pos[:y])
  end

  def is_accessible(x, y)
    get_at(x, y) == nil
  end

  def is_occupied (x, y)
    !is_accessible(x, y)
  end

end