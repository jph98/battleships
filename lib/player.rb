class Player

	:HUMAN = "human"
	:COMPUTER = "computer"

	attr_accessor :name, :board

	def initialize(name)
		@name = name
		@board = Board.new()
	end

end