# require 'sinatra'
require './game'
require './responder'

get '/' do
  "Welcome to Battle Bots!"
end

get '/game/start' do

  if game?
    @@game.stop
  end
  @@game = Game.new
  @@game.start

  "New game started"
end

get '/game/stop' do
  if !(defined?(@@game)).nil?
    @@game.stop
  end

  "Stopping game"
end


get '/game/turn' do
  r = Responder.new
  p "New responder"
  @@game.add_responder(r)
  r.wait_and_return {
    p "Has responded"
    @@game.display
  }
end


get '/player/add' do
  if game?
    p = @@game.add_player
    {
      success: true,
      id: p.id
    }.to_json
  else
    halt(500, {
        success: false,
        reason: "No active game"
      }.to_json)
  end
end


def game? 
  !(defined?(@@game)).nil?
end
