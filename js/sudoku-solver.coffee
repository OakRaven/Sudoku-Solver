# Sudoku Solver
define ->
  
  # modeled from Benny Pollak's JavaScript sudoku solver

  class SudokuSolver
    constructor: ->
      @puzzle = []
      @size = 0
      @squareSize = 0


    solve_cell: (row, col) ->
      if col >= @size
        return true
      else if row >= @size
        return @solve_cell 0, col + 1
      else if @puzzle[row][col] != 0
        return @solve_cell row + 1, col

      for num in [1..@size]
        if @valid(row, col, num)
          @set row, col, num
          if @solve_cell row+1, col
            return true

      @set row, col, 0
      return false


    solve: (puzzle) ->
      @puzzle = puzzle
      @size = @puzzle.length
      @squareSize = Math.sqrt @size

      @solve_cell 0, 0

      @puzzle


    set: (row, col, num) ->
      @puzzle[row][col] = num


    get: (row, col) ->
      @puzzle[row][col]


    valid: (row, col, num) ->
      isValid = @valid_in_row(row, col, num) and 
        @valid_in_col(row, col, num) and 
        @valid_in_square(row, col, num)

      return isValid


    valid_in_row: (row, col, num) ->
      for index in [0..@size - 1]
        return false if (index != col and @get(row, index) is num)
      return true


    valid_in_col: (row, col, num) ->
      for index in [0..@size - 1]
        return false if (index != row and @get(index, col) is num)
      return true


    valid_in_square: (row, col, num) ->
      r1 = Math.floor(row / @squareSize) * @squareSize
      c1 = Math.floor(col / @squareSize) * @squareSize

      for r in [r1..(r1 + @squareSize - 1)]
        for c in [c1..(c1 + @squareSize - 1)]
          return false if (r != row and c != col and @get(r, c) is num)

      return true
