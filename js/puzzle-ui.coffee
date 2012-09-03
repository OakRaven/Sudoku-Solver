# puzzle-ui.coffee
ARROWS = {
  UP: 38
  DOWN: 40
  LEFT: 37
  RIGHT: 39
}

class @PuzzleUi

  constructor: ->
    @currentlySelectedRow  = null
    @currentlySelectedCol  = null
    @currentlySelectedCell = null

    @samplePuzzle = [
      [0,0,0,0,0,0,7,4,0],
      [0,0,1,0,0,5,3,0,2],
      [0,3,4,7,0,0,0,5,6],
      [0,0,7,0,2,0,0,6,0],
      [0,0,0,9,0,3,0,0,0],
      [0,1,0,0,4,0,2,0,0],
      [5,4,0,0,0,7,9,2,0],
      [1,0,6,3,0,0,5,0,0],
      [0,7,8,0,0,0,0,0,0]
      ]

    @emptyPuzzle = [
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


  highlight: (cell) ->
    @unhighlight()

    row = $(cell).data 'row'
    col = $(cell).data 'col'

    $('#grid tr:nth-child(' + row + ') td').addClass 'highlight'
    $('#grid tr td:nth-child(' + col + ')').addClass 'highlight'
    
    @currentlySelectedRow = row
    @currentlySelectedCol = col


  hideEdit: (cell) ->
    $cell = $(cell)
    value = $cell.find('input').val()
    $cell.find('span').text value
    $(@currentlySelectedCell).removeClass 'selected-cell'


  displayEdit: (cell) ->
    if @currentlySelectedCell
      @hideEdit @currentlySelectedCell

    $(cell).addClass 'selected-cell'
    $(cell).find('input').select()
    @currentlySelectedCell = cell


  unhighlight: ->
    if @currentlySelectedCell
      @hideEdit @currentlySelectedCell

    $('#grid tr td').removeClass 'highlight'


  extractGridValues: ->
    values = []
    $.each $('#grid tr'), (rowIndex, rowPuzzle) ->
      row = []
      $.each $(rowPuzzle).find('td'), (colIndex, cellPuzzle) ->
        $span = $(cellPuzzle).find('span')
        row.push parseInt($span.text().trim()) || 0
      values.push row
    values


  set: (row, col, num, cssclass = null) ->
    $row = $('#grid tr:nth-child(' + (row + 1) + ')')
    $col = $($row).find('td:nth-child(' + (col + 1) + ')')

    $span = $($col).find('span')
    $input = $($col).find('input')

    if $span.text() is ''
      $span.addClass cssclass if cssclass
      $span.text num
      $input.val num
      $col.effect('highlight', {}, 1500) if cssclass


  clear_board: ->
    $('#grid td input').val('')
    $('#grid td span').text('')
    $('#grid td span').removeClass 'solved'


  pushSolution: (result) ->
    $('#grid td span').removeClass 'solved'
    rowIndex = 0

    for row in result
      colIndex = 0
      for col in row
        value = result[rowIndex][colIndex]
        cssclass = 'solved' ? value > 0 : null
        @set(rowIndex, colIndex, value, cssclass) if value
        colIndex += 1

      rowIndex += 1


  presetBoard: (puzzle) ->
    @clear_board()
    rowIndex = 0

    for row in puzzle
      colIndex = 0
      for col in row
        value = puzzle[rowIndex][colIndex]
        @set(rowIndex, colIndex, value) if value
        colIndex += 1

      rowIndex += 1


  move_selection: (direction) ->
    if @currentlySelectedCell
      cRow = $(@currentlySelectedCell).data 'row'
      cCol = $(@currentlySelectedCell).data 'col'

      if direction is ARROWS.DOWN
        cRow += 1
        cRow = 1 if cRow > 9

      if direction is ARROWS.UP
        cRow -= 1
        cRow = 9 if cRow < 1

      if direction is ARROWS.RIGHT
        cCol += 1
        cCol = 1 if cCol > 9

      if direction is ARROWS.LEFT
        cCol -= 1
        cCol = 9 if cCol < 1

      $td = $('#grid tr:nth-child(' + cRow + ')').find('td:nth-child(' + cCol + ')')
      @highlight $td
      $td.click()


  hide_alert: ->
    $('#alert-panel').hide()


  show_alert: ->
    $('#alert-panel').show()


  initializeBoard: ->
    $('#alert-panel .close').on 'click', =>
      @hide_alert()

    $('#grid').on 'mouseenter', 'td', (e) =>
      @highlight $(e.currentTarget)

    $('#grid').on 'click', 'td', (e) =>
      @displayEdit $(e.currentTarget)

    $('#grid').on 'mouseleave', 'table', (e) =>
      @unhighlight()

    $('#grid').on 'keypress', 'input', (e) =>
      keyPressed = String.fromCharCode(e.keyCode)
      if $.inArray(keyPressed, ['1', '2', '3', '4', '5', '6', '7', '8', '9']) is -1
        e.preventDefault()

    $('#solve-btn').on 'click', (e) => 
      e.preventDefault()
      gridValues = @extractGridValues()
      solver = new SudokuSolver(gridValues)
      if solver.is_valid_puzzle()
        result = solver.solve()
        @pushSolution result
      else
        @show_alert()

    $('#sample-btn').on 'click', (e) =>
      e.preventDefault()
      @presetBoard @samplePuzzle

    $('#clear-btn').on 'click', (e) =>
      e.preventDefault()
      @presetBoard @emptyPuzzle

    $('#hint-btn').on 'click', (e) =>
      e.preventDefault()
      gridValues = @extractGridValues()
      solver = new SudokuSolver(gridValues)
      if solver.is_valid_puzzle()
        hint = solver.get_hint()
        @set(hint.row, hint.column, hint.value, 'solved') if hint
      else
        @show_alert()

    $('#grid').on 'keydown', 'input', (e) =>
      key = e.keyCode
      if key is ARROWS.UP or key is ARROWS.DOWN or key is ARROWS.LEFT or key is ARROWS.RIGHT
        @move_selection(key)

