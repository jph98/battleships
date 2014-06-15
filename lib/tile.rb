class Tile

	EMPTY = :EMPTY
	H_OCCUPIED = :H_OCCUPIED
	V_OCCUPIED = :V_OCCUPIED
	DESTROYED = :DESTROYED

	attr_accessor :state
	
	def initialize(state)
		@state = state
	end

	def display()

		case @state

		when EMPTY
			return " "
		when H_OCCUPIED
			return "H"
		when V_OCCUPIED
			return "V"
		when DESTROYED
			return "D" 
		else
			raise "Tile state unknown"
		end
	end

	def to_s()
		return display()
	end

end