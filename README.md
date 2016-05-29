# Yaml Cutter
> non-intrusive editing of Yaml files

[![CircleCI](https://circleci.com/gh/kevgo/yaml-cutter.svg?style=shield)](https://circleci.com/gh/kevgo/yaml-cutter)


This npm module allows fine-grained programmatic editing
of YAML files.
It preserves the file structure,
including empty lines, comments, and indentation.


## Usage

* install the module

  ```
  $ npm install --save yaml-cutter
  ```

* load the library (in your JavaScript code):

  ```javascript
  yamlCutter = require('yaml-cutter');
  ```

* [insert data into a YAML file](features/add-key.feature)


## Development

see our [developer guidelines](CONTRIBUTING.md)
