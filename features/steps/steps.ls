require! {
  '../..' : yaml-cutter
  'fs'
  'jsdiff-console'
  'mkdirp'
  'livescript'
}


module.exports = ->

  @Given /^a file "([^"]*)" with content:$/, (@file-name, content) ->
    mkdirp.sync 'tmp'
    fs.write-file-sync @file-name, content


  @When /^running:$/, (code, done) ->
    js = livescript.compile code, bare: yes, header: no
    eval js


  @Then /^this file ends up with the content:$/, (expected-content, done) ->
    actual-content = fs.read-file-sync(@file-name).to-string!
    jsdiff-console actual-content, expected-content, done
