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

    unless id.nil?
        puts "Checking for id: #{id}"
        server_games.each_pair do |i,g|
            puts "Game: #{i}, #{g.state}"
        end
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

    return game
end

##################################################
# ROUTES
##################################################

# Display list of accounts and count of logdetails

def load_ships()

    config = YAML::load(File.open("battleships.yml"))
    puts "\nLoading ship configuration... total: #{config["ships"].size}"
    ships = []

    config["ships"].each_value do |s|
        ship = Ship.new(s["name"], s["number"], s["size"])
        ships << ship
    end

    return ships
end

post "/playersetup" do

    params.keys.each do |k|    
        puts "Key: #{k} value: #{params[k]}"
    end
    
    id = session['gameid']
    server_games = settings.server_games()
    puts "Place ships for player setup"
    puts "\n\n* Found existing game for gameid: #{id}"
    game = settings.server_games[id]
    player_number = session["current_player_number"]
    initialise_player_board(game, player_number)

    erb :main
end

post "/attack" do

    @messages = []
    id = session['gameid']
    server_games = settings.server_games
    game = server_games[id]
    current_player_number = session['current_player_number']
    other_player = game.players[current_player_number]
    board = other_player.get_board()

    coords = params[:coords]

    puts "\nATTACK from player: #{current_player_number} for space: #{coords}\n"

    unless coords.nil?

        tile = board.fire(coords)
        puts "Tile state is #{tile}"

        if tile.state == Tile::DESTROYED

            @messages << "Missed, you hit a piece that was already destroyed"
        elsif tile.state == Tile::H_OCCUPIED or tile.state == Tile::V_OCCUPIED

            tile.state = Tile::DESTROYED
            puts "Tile state #{tile.state}"

            ship_destroyed = other_player.ship_destroyed(tile)
        
            unless ship_destroyed.nil?
                @messages << "Kabooom, player destroyed ship - #{ship_destroyed.name}"
            else
                @messages << "Player hit part of ship"
            end
            
        else 
            @messages << "Missed"
        end

    else
        @messages << "Must enter coordinates"
    end

    other_player.display_board()

    erb :main
end

get "/" do

    #id = session['gameid'
    id = nil
    server_games = settings.server_games

    debug(id, server_games)

    if id.nil? or !server_games.include? id

        game = create_new_game(id, server_games)

        puts "Returning list of ships"
        @ships = load_ships()
        @ships.each do |s|
            puts s.name
        end
        erb :start

    else

        puts "\n\n* Found existing game for gameid: #{id}"
        puts "Checking for #{id}"
        game = settings.server_games[id]
        puts "Found Game: #{game.id} in state #{game.state} for players: #{game.players.size()}"

        player_number = session["current_player_number"]
        initialise_player_board(game, player_number)

        erb :main
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

    return player.board().to_json
end
