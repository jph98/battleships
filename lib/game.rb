require "yaml"

require_relative "player"

#
# Provides an entry point and a container for players
#
class Game

	attr_accessor :id, :state, :height, :width

	PLAYING = "playing"
	GAMEOVER = "gameover"

	attr_accessor :players

	def initialize()

		config = YAML::load(File.open("battleships.yml"))
		load_players(config)
		@id = SecureRandom.uuid
		puts "Generated gameid: #{id}"
		@state = Game::PLAYING
		@height = config["board_height"]
		@width = config["board_width"]
	end

	def load_players(config) 		

		puts "\nLoading players... total: #{config["players"].size}"
		@players = []
		config["players"].each_value do |p|
			puts "\tFound player: #{p}"
			player = Player.new(p["name"], p["type"])
			@players << player
		end		

		raise "Cannot create a game for less than 2 players" if @players.size < 2		
	end

	def get_players()
		
		# Yuck, but we need to provide a game loop outside here
		return @players
	end

	def over()

		@players.each do |p|
			if !p.has_ships_that_are_intact
				return false
			end
		end
		return true
	end

end