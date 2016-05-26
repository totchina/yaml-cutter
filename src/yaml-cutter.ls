require! {
  'fs'
  'nitroglycerin' : N
  'path'
  './yaml-hash-inserter' : YamlHashInserter
}


function read-file path, done
  fs.read-file path, N (text) ->
    done text.to-string!


function write-file path, content, done
  fs.write-file path, content, done


function insert-hash {file, root, value}, done
  (text) <- read-file file
  inserter = new YamlHashInserter text
  inserter.insert root, value
  write-file file, inserter.to-string!, done


module.exports = {insert-hash}

