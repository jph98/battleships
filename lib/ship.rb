class Ship

	attr_accessor :name, :number, :size

	def initialize(name, number, size)
		@name = name
		@number = number
		@size = size
	end

	def update(tiles, state)
		
		tiles.each do |t|
			t.state = state
		end
	end

	def is_sunk
		
		sunk = true
		tiles.each do |t|
			if t.state != DESTROYED
				sunk = false
				break
			end
		end
		return sunk
	end

end