require_relative "tile"

class Board

	ORIENTATION_VERTICAL = :ORIENTATION_VERTICAL
	ORIENTATION_HORIZONTAL = :ORIENTATION_HORIZONTAL
	ORIENTATION_DIAGONAL = :ORIENTATION_DIAGONAL

	def initialize(height, width)

		@height = height
		@width = width

		puts "Building board, height: #{height}, width: #{width}"
		@rows = {}

		(1..@width).each do |r|
			columns = []
			(1..@height).each do |c|
				columns << Tile.new(Tile::EMPTY)
			end 
			@rows[r] = columns
		end

	end

	def layout(ships)

		puts "Laying out ships"
		ships.each do |s|

			puts "\t" + s.name + " x " + s.number.to_s + ", size: " + s.size.to_s

			# Get size and calculate min and max start pos
			if place_ship(s)
				puts "Valid for ship"
			else
				puts "Not valid for ship"
			end

		end
	end

	def place_ship(s)

		min = 1
		max = @width - s.size
		rand_col_start_pos = rand(min..max)
		col_end_pos = rand_col_start_pos + (s.size - 1)

		# Make sure there's no ships already there
		rand_row_pos = rand(1..@height)
		cols = @rows[rand_row_pos]

		puts "Placing ship at: row: #{rand_row_pos}, col: #{rand_col_start_pos}"
		begin
			tiles = valid_for_ship(cols, rand_col_start_pos, col_end_pos)
			s.update(tiles)
			return true
		rescue
			return false
		end

	end

	def valid_for_ship(cols, start_pos, end_pos)

		tiles = []
		(start_pos..end_pos).each do |c|
			# Check tiles
			tile = cols[c]
			puts "Tile: [#{tile.state()}]"
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