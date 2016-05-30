require! {
  '../..' : yaml-cutter
  'chai' : {expect}
  'fs'
  'jsdiff-console'
  'mkdirp'
  'livescript'
}


module.exports = ->

  @Given /^a file "([^"]*)" with content:$/, (@file-name, content) ->
    mkdirp.sync 'tmp'
    fs.write-file-sync @file-name, content


  @When /^running:$/, (code, cb) ->
    done = (@error) ~> cb!
    eval livescript.compile(code, bare: yes, header: no)


  @Then /^it returns the error:/ (text) ->
    expect(@error).to.exist
    jsdiff-console @error.message, text


  @Then /^this file ends up with the content:$/, (expected-content) ->
    jsdiff-console fs.read-file-sync(@file-name).to-string!,
                   expected-content
