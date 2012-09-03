# puzzle-ui.coffee
define ['jquery', 'cs!sudoku-solver'], ($, Solver) ->

  class PuzzleUi

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


    highlightRow: (row) ->
      $(@currentlySelectedRow).removeClass 'highlight' if @currentlySelectedRow
      $(row).addClass 'highlight'
      @currentlySelectedRow = row


    highlightColumn: (col) ->
      if @currentlySelectedCol
        $('#grid tr td:nth-child(' + @currentlySelectedCol + ')').removeClass 'highlight'

      column = $(col).index() + 1

      $('#grid tr td:nth-child(' + (column) + ')').addClass 'highlight'
      @currentlySelectedCol  = column


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

      if @currentlySelectedCol
        $('#grid tr td:nth-child(' + @currentlySelectedCol + ')').removeClass 'highlight'

      if @currentlySelectedRow
        $(@currentlySelectedRow).removeClass 'highlight' 


    extractGridValues: ->
      values = []
      $.each $('#grid tr'), (rowIndex, rowPuzzle) ->
        row = []
        $.each $(rowPuzzle).find('td'), (colIndex, cellPuzzle) ->
          $span = $(cellPuzzle).find('span')
          row.push parseInt($span.text().trim()) || 0
        values.push row
      values


    pushSolution: (result) ->
      $.each result, (rowIndex, rowSolution) ->
        $tr = $('#grid tr:nth-child(' + (rowIndex + 1) + ')')
        $.each result[rowIndex], (colIndex, cellValue) ->
          $td = $($tr).find('td:nth-child(' + (colIndex + 1) + ')')
          $span = $($td).find('span')
          $input = $($td).find('input')

          value = $span.text()
          if value is ''
            $span.text cellValue
            $span.addClass('solved')
            $input.val cellValue

    presetBoard: (puzzle) ->
      $.each $('#grid tr'), (rowIndex, rowPuzzle) ->
        $.each $(rowPuzzle).find('td'), (colIndex, cellPuzzle) ->
          value = puzzle[rowIndex][colIndex]
          $input = $(cellPuzzle).find('input')
          $span = $(cellPuzzle).find('span')
          $span.removeClass 'solved'

          if value > 0
            $input.val value
            $span.text(puzzle[rowIndex][colIndex])
          else
            $input.val ''
            $span.text ''


    initializeBoard: ->
      $('#grid').on 'mouseenter', 'tr', (e) =>
        @highlightRow $(e.currentTarget)

      $('#grid').on 'mouseenter', 'td', (e) =>
        @highlightColumn $(e.currentTarget)

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
        solver = new Solver()
        result = solver.solve gridValues
        @pushSolution result


      $('#sample-btn').on 'click', (e) =>
        e.preventDefault()
        @presetBoard @samplePuzzle

      $('#clear-btn').on 'click', (e) =>
        e.preventDefault()
        @presetBoard @emptyPuzzle


