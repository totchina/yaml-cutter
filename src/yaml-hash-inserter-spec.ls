require! {
  'chai' : {expect}
  'jsdiff-console'
  './yaml-hash-inserter' : YamlHashInserter
}


describe 'YamlHashInserter', ->

  before-each ->
    @editor = new YamlHashInserter  """
      name: Example application
      description: An example app
      version: 1.0

      services:
        dashboard:
          location: ./dashboard
        web:
          location: ./web-server

      modules:
      """


  describe 'insert', (...) ->

    it 'inserts the given value at the given yaml path', ->
      @editor.insert-hash root: 'services', key: 'users', value: location: './users'
      expected-text = """
        name: Example application
        description: An example app
        version: 1.0

        services:
          dashboard:
            location: ./dashboard
          users:
            location: ./users
          web:
            location: ./web-server

        modules:
        """
      jsdiff-console @editor.to-string!, expected-text


    context 'the parent node has no children', (...) ->

      it 'inserts the given value', (done) ->
        @editor.insert-hash root: 'modules', key: 'users', value: {location: './users'}
        expected-text = """
          name: Example application
          description: An example app
          version: 1.0

          services:
            dashboard:
              location: ./dashboard
            web:
              location: ./web-server

          modules:
            users:
              location: ./users
          """
        jsdiff-console @editor.to-string!, expected-text, done


    context 'inserting as the last child', (...) ->

      it 'inserts the given value', (done) ->
        @editor.insert-hash root: 'services', key: 'zebra', value: {location: './zebra'}
        expected-text = """
          name: Example application
          description: An example app
          version: 1.0

          services:
            dashboard:
              location: ./dashboard
            web:
              location: ./web-server
            zebra:
              location: ./zebra

          modules:
          """
        jsdiff-console @editor.to-string!, expected-text, done


  describe 'go-to-child', ->

    context 'at root node', (...) ->

      before-each ->
        @editor.go-to-child 'services'

      it 'goes to the given child node', ->
        expect(@editor.cursor-line).to.equal 4

      it 'does not indent the cursor', ->
        expect(@editor.cursor-indentation).to.equal ''

      it 'updates the current json children', (done) ->
        expected =
          dashboard:
            location: './dashboard'
          web:
            location: './web-server'
        jsdiff-console @editor.current-json-children, expected, done


  describe 'go-to-next-empty-line', (...) ->

    it 'goes to the next empty line', ->
      @editor.go-to-next-empty-line!
      expect(@editor.cursor-line).to.equal 3
      @editor.cursor-line += 1
      @editor.go-to-next-empty-line!
      expect(@editor.cursor-line).to.equal 9
      @editor.cursor-line += 1
      @editor.go-to-next-empty-line!
      expect(@editor.cursor-line).to.equal 11



    context 'at branch node', (...) ->

      before-each ->
        @editor.go-to-child 'services'
        @editor.go-to-child 'web'

      it 'goes to the given child node', ->
        expect(@editor.cursor-line).to.equal 7

      it 'indents the cursor', ->
        expect(@editor.cursor-indentation).to.equal '  '

      it 'updates the current json children', (done) ->
        expected =
          location: './web-server'
        jsdiff-console @editor.current-json-children, expected, done


  describe 'has-child', (...) ->

    it 'returns true if the given child exists', ->
      expect(@editor.has-child 'services').to.be.true

    it 'returns false if the given child does not exist', ->
      expect(@editor.has-child 'zonk').to.be.false

    it 'returns false if the current node has no children', ->
      @editor.go-to-child 'modules'
      expect(@editor.has-child 'nope').to.be.false


  describe 'insert-line', (...) ->

    context 'at a branch level', (...) ->

      before-each ->
        @editor.go-to-child 'services'
        @editor.insert-line 'foo'

      it 'inserts the given line', (done) ->
        expected-text = """
          name: Example application
          description: An example app
          version: 1.0

          foo
          services:
            dashboard:
              location: ./dashboard
            web:
              location: ./web-server

          modules:
          """
        jsdiff-console @editor.to-string!, expected-text, done


  describe 'insert-branch-key', ->

    context 'at branch node', (...) ->

      before-each ->
        @editor.go-to-child 'services'
        @editor.insert-branch-key 'users'

      it 'inserts the given key', (done) ->
        expected-text = """
          name: Example application
          description: An example app
          version: 1.0

          services:
            dashboard:
              location: ./dashboard
            users:
            web:
              location: ./web-server

          modules:
          """
        jsdiff-console @editor.to-string!, expected-text, done

      it 'moves to the inserted line', ->
        expect(@editor.cursor-line).to.equal 7

      it 'increases the cursor indentation', ->
        expect(@editor.cursor-indentation).to.equal '  '


  describe 'insert-leaf', (...) ->

    before-each ->
      @editor.go-to-child 'services'
      @editor.insert-branch-key 'users'
      @editor.insert-leaf location: './users'

    it 'inserts the given data', (done) ->
      expected-text = """
        name: Example application
        description: An example app
        version: 1.0

        services:
          dashboard:
            location: ./dashboard
          users:
            location: ./users
          web:
            location: ./web-server

        modules:
        """
      jsdiff-console @editor.to-string!, expected-text, done


  describe 'key-segments', (...) ->

    it 'returns an array of key elements', ->
      expect(@editor.key-segments 'beta').to.eql ['beta']
      expect(@editor.key-segments 'alpha.beta.gamma').to.eql ['alpha', 'beta', 'gamma']
