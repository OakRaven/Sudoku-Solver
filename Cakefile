fs     = require 'fs'
{exec} = require 'child_process'

appFiles  = [
  'puzzle-ui'
  'sudoku-solver'
]

task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'lib/app.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile lib/app.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'lib/app.coffee', (err) ->
          throw err if err
          console.log 'Done.'

task 'minify', 'Minify the resulting application file after build', ->
  exec 'uglifyjs lib/app.js > lib/app.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'bm', 'Build and minify the application', ->
  exec 'cake build', (err, stdout, stderr) ->
    exec 'cake minify'