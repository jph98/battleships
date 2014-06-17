class Ship

	attr_accessor :name, :number, :size, :tiles

	def initialize(name, number, size)
		@name = name
		@number = number
		@size = size
	end

	def update(tiles, state)
		
		@tiles = tiles

		# TODO: Should this be here?
		tiles.each do |t|
			t.state = state
		end
	end

	def is_sunk
		
		sunk = true
		@tiles.each do |t|
			if t.state != Tile::DESTROYED
				return false
			end
		end
		puts "Sunk #{sunk}"
		return sunk
	end

end