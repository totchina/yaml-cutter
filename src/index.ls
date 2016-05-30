require! {
  'fs'
  'path'
  './yaml-hash-inserter' : YamlHashInserter
}


insert-hash = ({file, root, key, value}, done) ->
  fs.read-file file, (err, text) ->
    | err  =>  return done new Error "Cannot open the given YAML file '#{file}'! #{err.message}"
    inserter = new YamlHashInserter text.to-string!
    inserter.insert-hash {root, key, value}
    fs.write-file file, inserter.to-string!, done


module.exports = {insert-hash}

