# Lesson parser plugin for Embulk

TODO: Write short description here and embulk-parser-lesson.gemspec file.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **format_type**: simple or detail. choose how much information you want to show

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: active_support_log
    log_format: simple
```

## how to use
```
$ embulk gem install embulk-parser-lesson
$ embulk preview
```

## Build

```
$ rake
```
