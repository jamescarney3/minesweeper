class Board
  attr_reader :board

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

  def self.new_game_board
    board = Board.new
    board.give_coords
    board.seed_bombs
    board.each do |row|
      row.each do |tile|
        tile.find_neighbors
        tile.update_neighbor_bomb_count
      end
    end
    
    board
  end

  def display
    @board.each do |row|
      row.each do |col|
        if col.flagged
          print "F"
        elsif col.revealed
          print "_"
        elsif col.bombed
          print "B"
        else
          #print "*"
          print col.neighbor_bomb_count
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
attr_reader :flagged, :revealed, :neighbors, :neighbor_bomb_count
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
    neighbors.each do |neighbor|
      @neighbor_bomb_count += 1 if neighbor.bombed
    end
  end

  def find_neighbors(board)
    neighbor_coordinates = []
    ((coords[0]-1)..(coords[0]+1)).each do |row|
      ((coords[1]-1)..(coords[1]+1)).each do |col|
        neighbor_coordinates << [row, col] unless row == coords[0] && col == coords[1]
      end
    end

    neighbor_coordinates.delete_if do |coord|
      !(0..board.board.count).include?(coord[0]) || !(0..board.board.count).include?(coord[1])
    end

    neighbor_coordinates.each do |coord|
      @neighbors << board.board[coord[0]][coord[1]]
    end
  end

  def receive_coords
  end

end
