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
    eval livescript.compile(code, bare: yes, header: no)


  @Then /^this file ends up with the content:$/, (expected-content) ->
    jsdiff-console fs.read-file-sync(@file-name).to-string!,
                   expected-content
