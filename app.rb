# require 'sinatra'

require 'rubygems'
require 'bundler'
require 'pry'

Bundler.require

require './game_manager'
# require './responder'



class App < Sinatra::Application

  def gm?
    !(defined?(@@gm)).nil?
  end

  def create_gm_if_nil
    if !gm?
      @@gm = GameManager.new()
    end
  end

  def fail_if_gm_nil
    if !gm?
      halt(500, {
        success: false,
        reason: "Game Manager has not been created"
        }.to_json)
    end
  end

  get '/' do
    "Welcome to Battle Bots!"
  end

  get '/game' do
    fail_if_gm_nil
    p "Received turn"
    gm_response = @@gm.observe

    r = gm_response[:responder]

    r.wait_and_return {
      @@gm.display
    }
  end

  post '/game' do
    create_gm_if_nil
    @@gm.create_game
    
    p "Game created!"
  end

  delete '/game' do
    fail_if_gm_nil
    @@gm.stop
  end

  post '/game/start' do
    create_gm_if_nil
    if @@gm.has_game?
      @@gm.start
      p "Started game"
    else
      p "No game to start"
    end
  end

  post '/player' do
    fail_if_gm_nil

    if @@gm.is_running?
      p "Game in progress"
    else
      player = @@gm.add_player()
      JSON.generate(player.to_h)
    end
  end

  post '/game/turn' do
    fail_if_gm_nil
    p "Received turn"
    gm_response = @@gm.submit_turn(params)

    r = gm_response[:responder]
    pid = gm_response[:player_id]

    r.wait_and_return {
      @@gm.display({:player_id => pid})
    }
  end

end


# get '/game/start' do

#   if game?
#     @@gm.stop
#   end
#   @@gm = GameManager.new
#   @@gm.start

#   "New game started"
# end

# get '/game/stop' do
#   if !(defined?(@@gm)).nil?
#     @@gm.stop
#   end

#   "Stopping game"
# end


# get '/game/turn' do
#   r = Responder.new
#   p "New responder"
#   @@gm.add_responder(r)
#   r.wait_and_return {
#     p "Has responded"
#     @@gm.display
#   }
# end

# post '/game/turn' do
#   r = Responder.new
#   turn = TurnParser.parse_params(params)
#   @@gm.submit_turn(turn)
#   @@gm.add_responder(r)
  
#   r.wait_and_return {
#     p "Has responded"
#     @@gm.display
#   }
# end


# get '/player/add' do
#   if game?
#     p = @@gm.add_player
#     {
#       success: true,
#       id: p.id
#     }.to_json
#   else
#     halt(500, {
#         success: false,
#         reason: "No active game"
#       }.to_json)
#   end
# end


# def game? 
#   !(defined?(@@gm)).nil?
# end
