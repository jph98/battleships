#!/usr/bin/env ruby

require "sinatra"
require "json"

require_relative "lib/game.rb"

# Options
set :public_folder, "public"
enable :sessions
set :port, 5000
set :session_secret, "Battleships"

layout 'layout'

DEBUG = false

# Configure the initial application
configure do
  	set :show_exceptions, true
    set :server_games, {}
end

def alternate_player(current_player_number)

    puts "alternate #{current_player_number}"
    if current_player_number.eql? 0
        return 1
    else 
        return 0
    end
end

def debug(id, server_games)
    puts "Checking for id: #{id}"
    server_games.each_pair do |i,g|
        puts "Game: #{i}, #{g.state}"
    end
end


# Global error
error do
  	e = request.env['sinatra.error']
  	puts e.to_s
  	puts e.backtrace.join("\n")
  	"Application error"
end

def initialise_player_board(game, player_number) 

    session['current_player_number'] = player_number
    session['gamestate'] = game.state
    session['gameid'] = game.id
    session['height'] = game.height
    session['width'] = game.width

    puts "Players: #{game.players.size()}"

    player = game.players[player_number]
    puts "\nPlayer #{player.name}'s turn... board is:\n\n"
    player.display_board()
end

def create_new_game(id, server_games)

    puts "\n\n* Setting up new game, gameid does not exist: #{id}"

    game = Game.new()
    initial_player_number = 0
    player = game.players[initial_player_number]
    board = player.get_board()
    initialise_player_board(game, initial_player_number)

    # Save the board in the global server_games context
    settings.server_games[game.id] = game
    puts "Added new game: #{game.id}, size: #{settings.server_games.size()}"

end

##################################################
# ROUTES
##################################################

# Display list of accounts and count of logdetails

get "/start" do

    id = session['gameid']
    server_games = settings.server_games
    server_games[id] = nil  

    create_new_game(id, server_games) 

    erb :battleships
end

post "/attack" do

    id = session['gameid']
    server_games = settings.server_games
    game = server_games[id]
    current_player_number = session['current_player_number']
    other_player = game.players[current_player_number]
    board = other_player.get_board()

    coords = params[:coords]
    unless coords.nil?

        if (board.fire(coords))

            puts "Destroyed coordinates: #{coords}"
        else
            puts "Missed"
        end
    else
        puts "Must enter coordinates"
    end

    other_player.display_board()

    erb :battleships
end

get "/" do

    id = session['gameid']
    server_games = settings.server_games

    debug(id, server_games)

    if !id.nil? and !server_games.include? id

        create_new_game(id, server_games)

        erb :battleships

    else

        puts "\n\n* Found existing game for gameid #{id}"
        puts "Checking for #{id}"
        game = settings.server_games[id]
        puts "Found Game: #{game.id} in state #{game.state} for players: #{game.players.size()}"

        player_number = session["current_player_number"]
        initialise_player_board(game, player_number)

        erb :battleships
    end
end

# Get the board state for a game and player
get "/board/:gameid/player/:playernum" do

    content_type :json

    gameid = params['gameid']
    player_num = params['playernum']
    puts "received request for game: #{gameid} and playernum: #{player_num}"
    game = settings.server_games[gameid] 

    other_player_number = alternate_player(player_num)
    puts "displaying board for other player: #{other_player_number}"
    player = game.players[other_player_number]

    #rows = player.board().rows()    

    # This causes an issue when displaying the board a second time
    # rows["size"] = rows.size()
    # puts "Size #{rows['size']}"

    json_board = player.board().to_json
    puts "Board: #{json_board}"

    return json_board
end