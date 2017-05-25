#PsudoCode
# set up the board includeing the empty spaces 
# IF has_empty_cell
#   LOOP throught number 1 to 9
#   TRY Placing the number in a cell where the number does not exists in the box, column or row
#   IF solution found
#     display board
#   ELSE 
#     go back and try again in different position
#   END
# ENDIF
require 'benchmark'

#Code

class Sudoku

    BOARD_BOXES = {

    :one => [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]],
    :two => [[0, 3], [0, 4], [0, 5], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5]],
    :three => [[0, 6], [0, 7], [0, 8], [1, 6], [1, 7], [1, 8], [2, 6], [2, 7], [2, 8]],
    :four => [[3, 0], [3, 1], [3, 2], [4, 0], [4, 1], [4, 2], [5, 0], [5, 1], [5, 2]],
    :five => [[3, 3], [3, 4], [3, 5], [4, 3], [4, 4], [4, 5], [5, 3], [5, 4], [5, 5]],
    :six => [[3, 6], [3, 7], [3, 8], [4, 6], [4, 7], [4, 8], [5, 6], [5, 7], [5, 8]],
    :seven => [[6, 0], [6, 1], [6, 2], [7, 0], [7, 1], [7, 2], [8, 0], [8, 1], [8, 2]],
    :eight => [[6, 3], [6, 4], [6, 5], [7, 3], [7, 4], [7, 5], [8, 3], [8, 4], [8, 5]],
    :nine => [[6, 6], [6, 7], [6, 8], [7, 6], [7, 7], [7, 8], [8, 6], [8, 7], [8, 8]]
    }

  def initialize
    @found_solution = false
    @verbose = true
    @board_boxs = BOARD_BOXES
  end

  def has_empty_cell(arr, current_index)
    found = false
  	for row in (0...9)
  		for col in (0...9) 
  			if arr[row][col].include?('0')
          current_index[0] = row
          current_index[1] = col
          puts "Found Empty cell At [#{row}, #{col}]" if @verbose
          return true
        end
  		end
  	end
    # return found
  end

  def check_row(arr, row, num)
  	puts "Check number #{num} At Row #{row}" if @verbose
  	if arr[row].include?(num)
      puts "Found The Number #{num} At Row number #{row}" if @verbose
      return true
    end
  end

  def check_col(arr, col, num)
    found = false
  	puts "Check number #{num} at Column #{col}" if @verbose
  	for i in (0...9)
  		if arr[i][col].include?(num)
  			puts "Found number #{num} at [#{i}, #{col}]" if @verbose
        return true
  		end
  	end
    # return found
  end



  def check_box(arr, row, col, num)

    @board_boxs.each do |key, value|
      puts "Checking if the number #{num} already exist box #{key}" if @verbose
      if value.include?([row, col])
        value.each do |coords|
          if arr[coords[0]][coords[1]] == num
            puts "The number #{num} exist in Box #{key}" if @verbose
            return true
          end
        end
      end
    end
      
  end  

  def solve!(board)
    current_index = [0, 0]
      puts "Current Index #{current_index}" if @verbose
    if has_empty_cell(board, current_index) == true
      puts "Current Index #{current_index} after has_empty_cell with" if @verbose

      row = current_index[0]
      col = current_index[1]

      for number in ('1'...'10')
        puts number.inspect if @verbose

        if check_box(board, row, col, number) != true
          if check_row(board, row, number) != true && check_col(board, col, number) != true
            puts "Placing number #{number} at board position [#{row}, #{col}]" if @verbose
            puts "Previous Value is #{board[row][col]}" if @verbose
            
            board[row][col] = number
            display(board) if @verbose
            if solve!(board) == true
              puts "Solution found" if @verbose
              @found_solution = true
              return true
            else
              puts "No Solution Found... Removing number #{board[row][col]} from position [#{row}, #{col}]" if @verbose
              board[row][col] = '0'
              display(board) if @verbose
            end
          end
        end
      end
    else
      return true
    end
  end

  
  def display(board)
  	board.each {|row| puts row.inspect}
  end

end

# The file has newlines at the end of each line, so we call
# String#chomp to remove them.
board_string = File.readlines('board.txt').first.chomp

game = Sudoku.new

# Remember: this will just fill out what it can and not "guess"
@board = board_string.split(//).each_slice(9).to_a
game.display(@board)
puts 
puts
# run_time = Benchmark.measure{game.solve!(@board)}
puts
puts



start = Time.now
game.solve!(@board)
endt = Time.now

puts endt - start

game.display(@board)
