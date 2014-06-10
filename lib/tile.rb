class Tile

	EMPTY = :EMPTY
	OCCUPIED = :OCCUPIED
	DESTROYED = :DESTROYED

	attr_accessor :state
	
	def initialize(state)
		@state = state
	end

	def display()

		case @state

		when EMPTY
			return "_"
		when OCCUPIED
			return "*"
		when DESTROYED
			return "x" 
		else
			raise "Tile state unknown"
		end
	end

end