require! {
  'js-yaml' : yaml
  'prelude-ls' : {compact, elem-index}
}


# Inserts hash values into the given YAML text
class YamlHashInserter

  (@text) ->

    # array of lines of yaml code
    @lines = @text.split '\n'

    # the YML data parsed into a hash
    @data = yaml.safe-load @text

    # the line at which the cursor currently is
    @cursor-line = 0

    # the indentation at the current line,
    # in spaces
    @cursor-indentation = ''

    # the children of the current node
    @current-json-children = @data


  # Inserts the given hash value under the given root
  # Creates parent nodes if necessary
  #
  # params:
  #   - root: the parent node under which the new key should be inserted.
  #   - key: the key to insert
  #   - value: the value to insert
  insert-hash: ({root, key, value}) ->

    # create all parent nodes and move to the immediate parent
    for key-segment in @key-segments root
      @insert-branch-key key-segment

    # insert the key
    @insert-branch-key key

    # insert the value
    @insert-leaf value


  to-string: ->
    @lines.join "\n"


  # Moves the cursor to the child of the current line with the given name
  go-to-child: (child-name) ->
    indentation = if @cursor-line > 0
      "#{@cursor-indentation}  "
    else
      ''
    line-text = "#{indentation}#{child-name}:"
    for line-no from @cursor-line to @lines.length
      if @lines[line-no] is line-text
        @indent-cursor! if @cursor-line isnt 0
        @cursor-line = line-no
        @current-json-children = @current-json-children[child-name]
        return


  # Inserts the branch key segment as a child of the current line
  insert-branch-key: (key-segment) ->
    if @has-child key-segment
      @go-to-child key-segment
    else
      child-names = Object.keys @current-json-children
      child-names.push key-segment
      child-names.sort!
      parent-index = child-names.index-of(key-segment) + 1
      parent = child-names[parent-index]
      @go-to-child parent
      @insert-line "#{key-segment}:"


  # Inserts the given text with the current indentation
  # as a new line at the cursor position
  insert-line: (text) ->
    @lines.splice @cursor-line, 0, "#{@cursor-indentation}#{text}"


  # Inserts the given value as a leaf value
  # at the current cursor position
  insert-leaf: (hash) ->
    @cursor-line += 1
    for key, value of hash
      @insert-line "#{@cursor-indentation}#{key}: #{value}"


  # Returns whether the YAML file has the given node as a child of the current node
  has-child: (child-name) ->
    !!@current-json-children[child-name]


  indent-cursor: ->
    @cursor-indentation += '  '


  # Splits the given key into its segments
  key-segments: (key) ->
    key.split '.'  |>  compact



module.exports = YamlHashInserter
