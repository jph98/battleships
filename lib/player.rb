require_relative "board"
require_relative "ship"

class Player

	HUMAN = :HUMAN
	COMPUTER = :COMPUTER

	attr_accessor :name, :board

	def initialize(name, type)

		@name = name
		@type = type
		@ships = []

		layout_board()
	end

	def layout_board()

		config = YAML::load(File.open("battleships.yml"))
		@board = Board.new(config["board_height"], config["board_width"])		

		@ships = load_ships(config)
		board.layout(@ships)
	end

	def get_board()
		return @board
	end

	def load_ships(config)

		puts "\nLoading ship configuration... total: #{config["ships"].size}"
		ships = []

		config["ships"].each_value do |s|
			ship = Ship.new(s["name"], s["number"], s["size"])
			ships << ship
		end

		return ships
	end

	def display_board()

		@board.display()
	end

	def fire_shot(coords)

		return @board.validate(coords)
	end

	def has_ships_that_are_intact

		all_ships_sunk = true

		@ships.each do |s|

			if !s.is_sunk
				all_ships_sunk = false
			end

		end	
		return all_ships_sunk
	end

end