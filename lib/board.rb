require_relative "tile"

class Board

	def initialize(height, width)

		@height = height
		@width = width

		puts "Building board, height: #{height}, width: #{width}"

		# Build a hash of index -> tile_list
		@rows = {}

		(1..@width).each do |r|
			tiles = []
			(1..@height).each do |c|
				tiles << Tile.new(Tile::EMPTY)
			end 
			@rows[r] = tiles
		end
	end

	def layout(ships)

		puts "Laying out ships"

		num_vertical = ships.size / 2
		num_horizontal = ships.size - num_vertical

		puts "\nPlacing #{num_vertical} vertical ships and #{num_horizontal} horizontal ships\n\n"
		
		# TODO: Handle failure
		max_attempts = 3

		(1..num_vertical).each do |n|

			s = ships.first

			puts s.name + " x " + s.number.to_s + ", size: " + s.size.to_s

			# Get size and calculate min and max start pos
			if place_ship_vertical(s)
				puts "\tValid for ship"
				ships.shift
			else
				puts "Could not place ship #{s.name}"
				exit
			end
		end

		(1..num_horizontal).each do |n|

			s = ships.first

			puts s.name + " x " + s.number.to_s + ", size: " + s.size.to_s

			# Get size and calculate min and max start pos			
			if place_ship_horizontal(s)
				puts "\tValid for ship"
				ships.shift
			else				
				puts "Could not place ship #{s.name}"
				exit
			end
		end

		puts "Placed ships, size after placement #{ships.size}"
		# if ships.size > 0
		# 	raise "Could not place all the ships"
		# end
	end

	def place_ship_vertical(s)

		min = 1
		max = @height - s.size
		v_start_pos = rand(min..max)
		v_end_pos = v_start_pos + (s.size - 1)

		puts "#{v_start_pos} #{v_end_pos}"
		h_pos = rand(1..@width)

		tile_places = []

		# Grab all the vertical tiles using h_pos
		@rows.each_pair do |idx,tiles|
						
			tile_places << tiles[h_pos]

			# Only collect as many tiles as we need			
			if idx.eql? s.size
				break
			end
		end	

		puts "Placing ship vertically at: row: #{v_start_pos}, col: #{h_pos}"
		begin
			tiles = vert_valid_for_ship(tile_places, v_start_pos, v_end_pos)			
			s.update(tiles, Tile::V_OCCUPIED)
			return true
		rescue
			puts "Problem"
			return false
		end	
	end

	def place_ship_horizontal(s)

		min = 1
		max = @width - s.size
		h_start_pos = rand(min..max)
		h_end_pos = h_start_pos + (s.size - 1)

		# Make sure there's no ships already there
		v_pos = rand(1..@height)
		tile_places = @rows[v_pos]

		puts "Placing ship horizontally at: row: #{v_pos}, col: #{h_start_pos}"
		begin
			tiles = horz_valid_for_ship(tile_places, h_start_pos, h_end_pos)
			s.update(tiles, Tile::H_OCCUPIED)
			return true
		rescue
			return false
		end

	end

	def vert_valid_for_ship(tile_places, start_pos, end_pos)

		tiles = []

		puts "Checking from #{start_pos} to #{end_pos}"

		# Check tiles			
		tile_places.each do |tile|			
			puts "Tile: [#{tile.state()}]"
			unless tile.state == Tile::EMPTY				
				raise "Could not place ship"
			else
				tiles << tile
			end
		end		
		return tiles
	end

	def horz_valid_for_ship(tile_places, start_pos, end_pos)

		tiles = []
		(start_pos..end_pos).each do |c|
			# Check tiles
			tile = tile_places[c]
			print "#{tile.short_state()} "
			unless tile.state == Tile::EMPTY
				raise "Could not place ship"
			else
				tiles << tile
			end
		end
		return tiles
	end

	def update(coordinate)

		puts "Checking coordinate: #{coordinate}..."
	end

	def validate
		return true
	end

	def display()

		header = "  "

		(1..@width).each do |i|
			header += i.to_s + " "
		end

		puts "#{header}\n"

		@rows.each do |index, cols|

			row = convert_to_letter(index) + " "
			cols.each do |tile|
				row += tile.display() + " "
			end
			puts row
		end

	end

	def convert_to_letter(index)

		letter_idx = "#{index}".ord() + 16
		return letter_idx.chr()
	end

end