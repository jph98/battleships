class Ship

	attr_accessor :name, :number, :size

	def initialize(name, number, size)
		@name = name
		@number = number
		@size = size
	end

	def update(tiles)
		
		tiles.each do |t|
			t.state = Tile::OCCUPIED
		end
	end

	def is_sunk
		# Determines whether this is sunk or not
	end

end