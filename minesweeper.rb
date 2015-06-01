require 'byebug'

class Board
  attr_reader :board, :won, :lost

  BOARD_SIZE = 9
  BOMB_COUNT = 10

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {Tile.new}}
    @won = false
    @lost = false
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
    board.board.each do |row|
      row.each do |tile|
        tile.find_neighbors(board)
        tile.update_neighbor_bomb_count
      end
    end

    board
  end

  def update_board(coord, action)

    case action
    when :r
      if @board[coord[0]][coord[1]].bombed
        @lost = true
      else
        @board[coord[0]][coord[1]].reveal_neighbors
      end
    when :f
      if @board[coord[0]][coord[1]].flagged
        @board[coord[0]][coord[1]].flagged = false
      else
        @board[coord[0]][coord[1]].flagged = true
      end
    end

  end

  def is_won?
    @board.each do |row|
      row.each do |tile|
        return false if !tile.bombed && !tile.revealed
      end
    end

    true
  end

  def display
    @board.each do |row|
      row.each do |tile|
        if tile.flagged
          print "F"
        elsif tile.revealed
          print tile.neighbor_bomb_count
        elsif tile.bombed
          print "*"
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
attr_reader :neighbors
attr_accessor :bombed, :coords, :flagged, :revealed, :neighbor_bomb_count

  def initialize
    @bombed = false
    @flagged = false
    @revealed = false
    @neighbor_bomb_count = 0
    @neighbors = []
    @coords = nil
  end

  def update_neighbor_bomb_count
    self.neighbors.each do |neighbor|
      self.neighbor_bomb_count += 1 if neighbor.bombed
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
      !(0...board.board.count).include?(coord[0]) || !(0...board.board.count).include?(coord[1])
    end

    neighbor_coordinates.each do |coord|
      @neighbors << board.board[coord[0]][coord[1]]
    end
  end

  def reveal_neighbors
    queue = [self]
    checked = [self]
    until queue.empty?
      if queue.first.neighbor_bomb_count == 0
        neighbors.each do |neighbor|
          queue << neighbor unless checked.include?(neighbor)
          checked << neighbor
        end
      end
      queue.shift.revealed = true
    end
  end

  def receive_coords
  end

end


class Game

  def initialize
    @board = Board.new_game_board
  end

  def take_turn
    puts "Which tile? (format: row, column)"
    coord = gets.chomp.split(", ").map(&:to_i)
    puts "Reveal or flag? (r or f)"
    action = gets.chomp.downcase.to_sym

    [coord, action]
  end

  def play
    until @board.won || @board.lost
      turn_input = take_turn
      @board.update_board(*turn_input)
      @board.display
    end


  end

end
