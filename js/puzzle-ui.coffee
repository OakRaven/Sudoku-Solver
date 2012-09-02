# puzzle-ui.coffee
define ['jquery'], ($) ->

  class PuzzleUi

    constructor: ->
      @currentlySelectedRow  = null
      @currentlySelectedCol  = null
      @currentlySelectedCell = null


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
      

    initializeBoard: ->
      $('#grid').on 'mouseenter', 'tr', (e) =>
        @highlightRow $(e.currentTarget)

      $('#grid').on 'mouseenter', 'td', (e) =>
        @highlightColumn $(e.currentTarget)

      $('#grid').on 'click', 'td', (e) =>
        @displayEdit $(e.currentTarget)

      $('#grid').on 'mouseleave', 'table', (e) =>
        @unhighlight()


