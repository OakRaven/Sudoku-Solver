require(['jquery', 'cs!sudoku-solver', 'cs!puzzle-ui'], function($, SudokuSolver, Ui){
  $(function(){
    var
      solver =  new SudokuSolver(),
      ui =      new Ui();

      ui.initializeBoard();
  });
});