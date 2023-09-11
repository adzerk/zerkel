# Zerkel Cli

## Summary

Simple zerkel validator cli tool that uses the [`adzerk/zerkel`](https://github.com/adzerk/zerkel) library.

## Usage

Cli options available with `zerkel --help`.

1. Install the tool with `npm install --global @adzerk/zerkel-cli`.
1. Run the command with `zerkel validate [expression]`
1. That's it!

## Output Format

```yaml
---
"$schema": http://json-schema.org/draft-07/schema
title: Zerkel Validation Result
required:
- body
- result
properties:
  body:
    title: Body
    type: object
    required:
    - code
    - version
    properties:
      code:
        title: Code
        description: Result information.
        type: string
      version:
        title: Version
        description: Parser version.
        type: string
        pattern: "^[0-9]+\\.[0-9]+\\.[0-9]+$"
  result:
    title: Result
    description: Whether or not the validation was successful.
    enum:
    - failure
    - success
```

