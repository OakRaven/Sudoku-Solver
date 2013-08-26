// Generated by CoffeeScript 1.3.3
(function() {
  var ARROWS;

  ARROWS = {
    UP: 38,
    DOWN: 40,
    LEFT: 37,
    RIGHT: 39
  };

  this.PuzzleUi = (function() {

    function PuzzleUi() {
      this.currentlySelectedRow = null;
      this.currentlySelectedCol = null;
      this.currentlySelectedCell = null;
      this.samplePuzzle = [[0, 0, 0, 0, 0, 0, 7, 4, 0], [0, 0, 1, 0, 0, 5, 3, 0, 2], [0, 3, 4, 7, 0, 0, 0, 5, 6], [0, 0, 7, 0, 2, 0, 0, 6, 0], [0, 0, 0, 9, 0, 3, 0, 0, 0], [0, 1, 0, 0, 4, 0, 2, 0, 0], [5, 4, 0, 0, 0, 7, 9, 2, 0], [1, 0, 6, 3, 0, 0, 5, 0, 0], [0, 7, 8, 0, 0, 0, 0, 0, 0]];
      this.emptyPuzzle = [[0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0]];
    }

    PuzzleUi.prototype.buildTable = function() {
      var col, row, tableHtml, _i, _j;
      tableHtml = "";
      for (row = _i = 1; _i <= 9; row = ++_i) {
        tableHtml += "<tr>";
        for (col = _j = 1; _j <= 9; col = ++_j) {
          tableHtml += "<td data-row=\"" + row + "\" data-col=\"" + col + "\"><input type=\"text\" maxlength=\"1\" value=\"\"><span></span></td>";
        }
        tableHtml += "</tr>";
      }
      return $('#grid table').append(tableHtml);
    };

    PuzzleUi.prototype.highlight = function(cell) {
      var col, row;
      this.unhighlight();
      row = $(cell).data('row');
      col = $(cell).data('col');
      $('#grid tr:nth-child(' + row + ') td').addClass('highlight');
      $('#grid tr td:nth-child(' + col + ')').addClass('highlight');
      this.currentlySelectedRow = row;
      return this.currentlySelectedCol = col;
    };

    PuzzleUi.prototype.hideEdit = function(cell) {
      var $cell, value;
      $cell = $(cell);
      value = $cell.find('input').val();
      $cell.find('span').text(value);
      return $(this.currentlySelectedCell).removeClass('selected-cell');
    };

    PuzzleUi.prototype.displayEdit = function(cell) {
      if (this.currentlySelectedCell) {
        this.hideEdit(this.currentlySelectedCell);
      }
      $(cell).addClass('selected-cell');
      $(cell).find('input').select();
      return this.currentlySelectedCell = cell;
    };

    PuzzleUi.prototype.unhighlight = function() {
      if (this.currentlySelectedCell) {
        this.hideEdit(this.currentlySelectedCell);
      }
      return $('#grid tr td').removeClass('highlight');
    };

    PuzzleUi.prototype.extractGridValues = function() {
      var values;
      values = [];
      $.each($('#grid tr'), function(rowIndex, rowPuzzle) {
        var row;
        row = [];
        $.each($(rowPuzzle).find('td'), function(colIndex, cellPuzzle) {
          var $span;
          $span = $(cellPuzzle).find('span');
          return row.push(parseInt($span.text().trim()) || 0);
        });
        return values.push(row);
      });
      return values;
    };

    PuzzleUi.prototype.set = function(row, col, num, cssclass) {
      var $col, $input, $row, $span;
      if (cssclass == null) {
        cssclass = null;
      }
      $row = $('#grid tr:nth-child(' + (row + 1) + ')');
      $col = $($row).find('td:nth-child(' + (col + 1) + ')');
      $span = $($col).find('span');
      $input = $($col).find('input');
      if ($span.text() === '') {
        if (cssclass) {
          $span.addClass(cssclass);
        }
        $span.text(num);
        $input.val(num);
        if (cssclass) {
          return $col.effect('highlight', {}, 1500);
        }
      }
    };

    PuzzleUi.prototype.clear_board = function() {
      $('#grid td input').val('');
      $('#grid td span').text('');
      return $('#grid td span').removeClass('solved');
    };

    PuzzleUi.prototype.pushSolution = function(result) {
      var col, colIndex, cssclass, row, rowIndex, value, _i, _j, _len, _len1, _results;
      $('#grid td span').removeClass('solved');
      rowIndex = 0;
      _results = [];
      for (_i = 0, _len = result.length; _i < _len; _i++) {
        row = result[_i];
        colIndex = 0;
        for (_j = 0, _len1 = row.length; _j < _len1; _j++) {
          col = row[_j];
          value = result[rowIndex][colIndex];
          cssclass = 'solved' != null ? 'solved' : value > {
            0: null
          };
          if (value) {
            this.set(rowIndex, colIndex, value, cssclass);
          }
          colIndex += 1;
        }
        _results.push(rowIndex += 1);
      }
      return _results;
    };

    PuzzleUi.prototype.presetBoard = function(puzzle) {
      var col, colIndex, row, rowIndex, value, _i, _j, _len, _len1, _results;
      this.clear_board();
      rowIndex = 0;
      _results = [];
      for (_i = 0, _len = puzzle.length; _i < _len; _i++) {
        row = puzzle[_i];
        colIndex = 0;
        for (_j = 0, _len1 = row.length; _j < _len1; _j++) {
          col = row[_j];
          value = puzzle[rowIndex][colIndex];
          if (value) {
            this.set(rowIndex, colIndex, value);
          }
          colIndex += 1;
        }
        _results.push(rowIndex += 1);
      }
      return _results;
    };

    PuzzleUi.prototype.move_selection = function(direction) {
      var $td, cCol, cRow;
      if (this.currentlySelectedCell) {
        cRow = $(this.currentlySelectedCell).data('row');
        cCol = $(this.currentlySelectedCell).data('col');
        if (direction === ARROWS.DOWN) {
          cRow += 1;
          if (cRow > 9) {
            cRow = 1;
          }
        }
        if (direction === ARROWS.UP) {
          cRow -= 1;
          if (cRow < 1) {
            cRow = 9;
          }
        }
        if (direction === ARROWS.RIGHT) {
          cCol += 1;
          if (cCol > 9) {
            cCol = 1;
          }
        }
        if (direction === ARROWS.LEFT) {
          cCol -= 1;
          if (cCol < 1) {
            cCol = 9;
          }
        }
        $td = $('#grid tr:nth-child(' + cRow + ')').find('td:nth-child(' + cCol + ')');
        this.highlight($td);
        return this.displayEdit($td);
      }
    };

    PuzzleUi.prototype.hide_alert = function() {
      return $('#alert-panel').hide();
    };

    PuzzleUi.prototype.show_alert = function() {
      return $('#alert-panel').show();
    };

    PuzzleUi.prototype.initializeBoard = function() {
      var _this = this;
      this.buildTable();
      $('#alert-panel .close').on('click', function() {
        return _this.hide_alert();
      });
      $('#grid').on('mouseenter', 'td', function(e) {
        return _this.highlight($(e.currentTarget));
      });
      $('#grid').on('click', 'td', function(e) {
        return _this.displayEdit($(e.currentTarget));
      });
      $('#grid').on('mouseleave', 'table', function(e) {
        return _this.unhighlight();
      });
      $('#grid').on('keypress', 'input', function(e) {
        var keyPressed;
        keyPressed = String.fromCharCode(e.keyCode);
        if ($.inArray(keyPressed, ['1', '2', '3', '4', '5', '6', '7', '8', '9']) === -1) {
          return e.preventDefault();
        }
      });
      $('#solve-btn').on('click', function(e) {
        var gridValues, result, solver;
        e.preventDefault();
        gridValues = _this.extractGridValues();
        solver = new SudokuSolver(gridValues);
        if (solver.is_valid_puzzle()) {
          result = solver.solve();
          return _this.pushSolution(result);
        } else {
          return _this.show_alert();
        }
      });
      $('#sample-btn').on('click', function(e) {
        e.preventDefault();
        return _this.presetBoard(_this.samplePuzzle);
      });
      $('#clear-btn').on('click', function(e) {
        e.preventDefault();
        return _this.presetBoard(_this.emptyPuzzle);
      });
      $('#hint-btn').on('click', function(e) {
        var gridValues, hint, solver;
        e.preventDefault();
        gridValues = _this.extractGridValues();
        solver = new SudokuSolver(gridValues);
        if (solver.is_valid_puzzle()) {
          hint = solver.get_hint();
          if (hint) {
            return _this.set(hint.row, hint.column, hint.value, 'solved');
          }
        } else {
          return _this.show_alert();
        }
      });
      return $('#grid').on('keydown', 'input', function(e) {
        var key;
        key = e.keyCode;
        if (key === ARROWS.UP || key === ARROWS.DOWN || key === ARROWS.LEFT || key === ARROWS.RIGHT) {
          e.preventDefault();
          return _this.move_selection(key);
        }
      });
    };

    return PuzzleUi;

  })();

  this.SudokuSolver = (function() {

    function SudokuSolver(puzzle) {
      this.puzzle = puzzle;
      this.size = this.puzzle.length;
      this.squareSize = Math.sqrt(this.puzzle.length);
      this.hints = [];
    }

    SudokuSolver.prototype.solve_cell = function(row, col) {
      var num, _i, _ref;
      if (col >= this.size) {
        return true;
      } else if (row >= this.size) {
        return this.solve_cell(0, col + 1);
      } else if (this.puzzle[row][col] !== 0) {
        return this.solve_cell(row + 1, col);
      }
      for (num = _i = 1, _ref = this.size; 1 <= _ref ? _i <= _ref : _i >= _ref; num = 1 <= _ref ? ++_i : --_i) {
        if (this.valid(row, col, num)) {
          this.set(row, col, num);
          if (this.solve_cell(row + 1, col)) {
            return true;
          }
        }
      }
      this.set(row, col, 0);
      return false;
    };

    SudokuSolver.prototype.solve = function() {
      this.attempts = 0;
      this.hints = [[0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0]];
      this.solve_cell(0, 0);
      return this.puzzle;
    };

    SudokuSolver.prototype.get_hint = function() {
      var col, hint_array, hint_number, row, _i, _j, _ref, _ref1;
      this.solve();
      hint_array = [];
      for (row = _i = 0, _ref = this.size - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; row = 0 <= _ref ? ++_i : --_i) {
        for (col = _j = 0, _ref1 = this.size - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
          if (this.hints[row][col] !== 0) {
            hint_array.push({
              row: row,
              column: col,
              value: this.hints[row][col]
            });
          }
        }
      }
      if (hint_array.length > 0) {
        hint_number = Math.floor((Math.random() * hint_array.length) + 1);
        return hint_array[hint_number];
      }
      return null;
    };

    SudokuSolver.prototype.set = function(row, col, num) {
      this.puzzle[row][col] = num;
      return this.hints[row][col] = num;
    };

    SudokuSolver.prototype.get = function(row, col) {
      return this.puzzle[row][col];
    };

    SudokuSolver.prototype.is_valid_puzzle = function() {
      var col, row, value, _i, _j, _ref, _ref1;
      for (row = _i = 0, _ref = this.size - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; row = 0 <= _ref ? ++_i : --_i) {
        for (col = _j = 0, _ref1 = this.size - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
          value = this.puzzle[row][col];
          if (value > 0) {
            if (!this.valid(row, col, value)) {
              return false;
            }
          }
        }
      }
      return true;
    };

    SudokuSolver.prototype.valid = function(row, col, num) {
      var isValid;
      isValid = this.valid_in_row(row, col, num) && this.valid_in_col(row, col, num) && this.valid_in_square(row, col, num);
      return isValid;
    };

    SudokuSolver.prototype.valid_in_row = function(row, col, num) {
      var index, _i, _ref;
      for (index = _i = 0, _ref = this.size - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
        if (index !== col && this.get(row, index) === num) {
          return false;
        }
      }
      return true;
    };

    SudokuSolver.prototype.valid_in_col = function(row, col, num) {
      var index, _i, _ref;
      for (index = _i = 0, _ref = this.size - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
        if (index !== row && this.get(index, col) === num) {
          return false;
        }
      }
      return true;
    };

    SudokuSolver.prototype.valid_in_square = function(row, col, num) {
      var c, c1, r, r1, _i, _j, _ref, _ref1;
      r1 = Math.floor(row / this.squareSize) * this.squareSize;
      c1 = Math.floor(col / this.squareSize) * this.squareSize;
      for (r = _i = 0, _ref = this.squareSize - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; r = 0 <= _ref ? ++_i : --_i) {
        for (c = _j = 0, _ref1 = this.squareSize - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; c = 0 <= _ref1 ? ++_j : --_j) {
          if ((r1 + r) !== row && (c1 + c) !== col && this.get(r1 + r, c1 + c) === num) {
            return false;
          }
        }
      }
      return true;
    };

    return SudokuSolver;

  })();

}).call(this);