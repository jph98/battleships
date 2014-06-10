require "yaml"

class Game

	@players = []

	def initialize()

		config = YAML::load(File.open("battleships.yml"))

		config.players.each do |p|
			"Loaded player #{p}"
		end

		raise "Cannot create a game for less than 2 players" if player.size < 2

		@players = players
	end

	def start()
		
		@players.each do |p|
			puts "Turn for player #{p}"
			player.take_turn()
		end				
	end

end