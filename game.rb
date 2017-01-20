require 'thread'
require './responder'
require './board'
require './player'
class Game

  def initialize(width = 5, height = 5)
    @board = Board.new(width, height)
    @mutex = Mutex.new
    @responders = Array.new
  end

  def start(seconds_per_tick = 1, dt=0.1)
    @ticks = 0
    @playing = true
    p "Starting game"
    @game_thread = Thread.new{
      p "Starting loop"
      game_loop(seconds_per_tick, dt)
    }
  end

  def stop
    # p "Killing game thread"
    @playing = false
    @game_thread.exit
    @game_thread.join
  end

  def game_loop(seconds_per_tick, dt)
    last_tick = Time.now
    while @playing do
      sleep dt
      # p "Waking up"
      # p (Time.now - last_tick).to_s
      # p ((Time.now - last_tick) >= seconds_per_tick).to_s
      if (Time.now - last_tick) >= seconds_per_tick
        # p "Execute tick"
        last_tick += seconds_per_tick
        game_tick()
      end
    end
  end

  def game_tick()  
    @ticks += 1
    respond
  end

  def add_responder(responder)
    @mutex.synchronize do
      @responders << responder
    end
  end

  def respond
    @mutex.synchronize do
      while @responders.length > 0
        r = @responders.shift
        r.allow_return
      end
    end
  end

  def display
    {
      "current-turn": @ticks
    }.to_json
  end

  def add_player
    p = Player.new
    @mutex.synchronize do
      @board.add_player p
    end

    p
  end


end