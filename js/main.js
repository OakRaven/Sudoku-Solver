require(['jquery', 'cs!sudoku-solver'], function($, SudokuSolver){
  $(function(){
    var solver = new SudokuSolver();
    solver.alert();
  });
});