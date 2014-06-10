require_relative "board"
require_relative "ship"

class Player

	HUMAN = :HUMAN
	COMPUTER = :COMPUTER

	attr_accessor :name, :board

	def initialize(name, type, ships)
		@name = name
		@type = type
		@ships = ships
		
		@board = Board.new()
	end

end