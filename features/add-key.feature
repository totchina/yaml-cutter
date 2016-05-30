Feature: adding keys

  As a framework developer
  I want my framework to be able to programmatically add keys to existing YAML files
  So that my framework can seamlessly add features to existing software.

  - call "yaml-cutter.add-key file: [file path], root: [root node], value: [value to insert]"
    to add the given key at the given position into the given YAML file


  Scenario: inserting the first child into an empty node
    Given a file "tmp/foo.yaml" with content:
      """
      name: Example application
      description: An example app
      version: 1.0

      services:
      """
    When running:
      """
      yaml-cutter.insert-hash file: 'tmp/foo.yaml', root: 'services', key: 'users', value: location: './users', done
      """
    Then this file ends up with the content:
      """
      name: Example application
      description: An example app
      version: 1.0

      services:
        users:
          location: ./users
      """


  Scenario: adding a child in the middle of a node
    Given a file "tmp/foo.yaml" with content:
      """
      name: Example application
      description: An example app
      version: 1.0

      services:
        dashboard:
          location: ./dashboard
        web:
          location: ./web-server
      """
    When running:
      """
      yaml-cutter.insert-hash file: 'tmp/foo.yaml', root: 'services', key: 'users', value: location: './users', done
      """
    Then this file ends up with the content:
      """
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
      """


  Scenario: adding a child to the end of a node
    Given a file "tmp/foo.yaml" with content:
      """
      name: Example application
      description: An example app
      version: 1.0

      services:
        dashboard:
          location: ./dashboard
        users:
          location: ./users
      """
    When running:
      """
      yaml-cutter.insert-hash file: 'tmp/foo.yaml', root: 'services', key: 'web', value: location: './web-server', done
      """
    Then this file ends up with the content:
      """
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
      """

