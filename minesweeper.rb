class Board
  BOARD_SIZE = 9
  BOMB_COUNT = 10

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE)}

  end

  def seed_bombs
    bomb_coords = []
    until bomb_coords.count == BOMB_COUNT
      bomb_coord = [rand(BOARD_SIZE), rand(BOARD_SIZE)]
      bomb_coords << bomb_coord unless bomb_coords.include?(bomb_coord)
    end

    bomb_coords.each do |bomb_coord|
      @board[bomb_coord[0]][bomb_coord[1]] = :bomb
    end
  end

  def display
    @board.each do |row|
      print row
      puts ''
    end
  end
end

board = Board.new
board.display
