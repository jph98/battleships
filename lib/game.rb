require "yaml"

require_relative "player"

class Game

	def initialize()

		config = YAML::load(File.open("battleships.yml"))
		load_players(config)
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

	def start()
		
		puts "\nStarting game..."

		@players.each do |p|
			puts "\nPlayer #{p.name}'s turn...\n\n"

			# Display the other players board
			p.display_board()
			
			print "\nEnter co-ordinates to attaaackkk: "
			coord = gets.chomp
			unless coord.empty?
				p.fire_shot(coord)
			end
			
		end				
	end

end