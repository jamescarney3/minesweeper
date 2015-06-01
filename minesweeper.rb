class Board
  BOARD_SIZE = 9
  BOMB_COUNT = 10

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {Tile.new}}
  end

  def give_coords
    @board.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        tile.coords = [row_idx, col_idx]
      end
    end
  end

  def seed_bombs
    bomb_coords = []
    until bomb_coords.count == BOMB_COUNT
      bomb_coord = [rand(BOARD_SIZE), rand(BOARD_SIZE)]
      bomb_coords << bomb_coord unless bomb_coords.include?(bomb_coord)
    end

    bomb_coords.each do |bomb_coord|
      @board[bomb_coord[0]][bomb_coord[1]].bombed = true
    end
  end

  def display
    @board.each do |row|
      row.each do |col|
        if col.flagged
          print "F"
        elsif col.revealed
          print "_"
        #elsif col.bombed
          #print "B"
        else
          print "*"
        end
      end

      puts ""
    end

    nil
  end

end

#board = Board.new
#board.display

class Tile
attr_reader :flagged, :revealed
attr_accessor :bombed, :coords

  def initialize
    @bombed = false
    @flagged = false
    @revealed = false
    @neighbor_bomb_count = 0
    @neighbors = []
    @coords = nil
  end

  def update_neighbor_bomb_count
    unless Tile.bombed

    end

  end

end
