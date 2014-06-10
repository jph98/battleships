require "yaml"

require_relative "player"

class Game

	def initialize()

		config = YAML::load(File.open("battleships.yml"))
		
		load_players(config)
	end

	def load_players(config) 		

		ships = load_ships(config)	

		puts "\nLoading players... total: #{config["players"].size}"
		@players = []
		config["players"].each_value do |p|
			puts "\tFound player: #{p}"
			@players << Player.new(p["name"], p["type"], ships)
		end		

		raise "Cannot create a game for less than 2 players" if @players.size < 2		
	end

	def load_ships(config)

		puts "\nLoading ship configuration... total: #{config["ships"].size}"
		ships = []

		config["ships"].each_value do |s|
			ships << Ship.new(s["name"], s["number"], s["size"])
		end

		return ships
	end

	def start()
		
		puts "\nStarting game..."

		@players.each do |p|
			puts "Turn for player #{p}"
			#p.take_turn()
		end				
	end

end