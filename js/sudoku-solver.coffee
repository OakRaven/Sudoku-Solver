# Sudoku Solver

# modeled from Benny Pollak's JavaScript sudoku solver
class @SudokuSolver
  constructor: (@puzzle) ->
    @size = @puzzle.length
    @squareSize = Math.sqrt(@puzzle.length)
    @hints = []


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


  solve: ->    
    @attempts = 0
    @hints = [
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0]
      ]

    @solve_cell 0, 0
    @puzzle


  get_hint: ->
    @solve()
    hint_array = []

    for row in [0..(@size - 1)]
      for col in [0..(@size - 1)]
        if @hints[row][col] != 0
          hint_array.push
            row: row
            column: col
            value: @hints[row][col]

    if hint_array.length > 0
      hint_number = Math.floor((Math.random()*hint_array.length)+1)
      return hint_array[hint_number]

    return null

  set: (row, col, num) ->
    if @attempts > 10000
      throw "Invalid puzzle?"
    
    else 
      @attempts += 1
      @puzzle[row][col] = num
      @hints[row][col] = num

  get: (row, col) ->
    @puzzle[row][col]


  is_valid_puzzle: ->
    for row in [0..(@size - 1)]
      for col in [0..(@size - 1)]
        value = @puzzle[row][col]
        if value > 0
          if !@valid(row, col, value)
            return false
    return true


  valid: (row, col, num) ->
    isValid = @valid_in_row(row, col, num) and 
      @valid_in_col(row, col, num) and 
      @valid_in_square(row, col, num)

    return isValid


  valid_in_row: (row, col, num) ->
    for index in [0..(@size - 1)]
      return false if (index != col and @get(row, index) is num)
    return true


  valid_in_col: (row, col, num) ->
    for index in [0..(@size - 1)]
      return false if (index != row and @get(index, col) is num)
    return true


  valid_in_square: (row, col, num) ->
    r1 = Math.floor(row / @squareSize) * @squareSize
    c1 = Math.floor(col / @squareSize) * @squareSize

    for r in [0..(@squareSize - 1)]
      for c in [0..(@squareSize - 1)]
        return false if ((r1 + r )!= row and (c1 + c) != col and @get((r1 + r), (c1 + c)) is num)

    return true
