# Pngdefry.cr

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/pngdefry.cr.svg)](https://github.com/icyleaf/pngdefry.cr/blob/master/CHANGELOG.md)

Pngdefry.cr is a wrapper for [pngdefry](http://www.jongware.com/pngdefry.html) that reverses the optimization Xcode does on png image included
into ipa files to make the images readable by the browser.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pngdefry:
    github: icyleaf/pngdefry
```

## Usage

```crystal
require "pngdefry"

Pngdefry.decode("input.png", "output.png")
```

## How to Contribute

Your contributions are always welcome! Please submit a pull request or create an issue to add a new question, bug or feature to the list.

All [Contributors](https://github.com/icyleaf/pngdefry.cr/graphs/contributors) are on the wall.

## You may also like

- [security.cr](https://github.com/icyleaf/security.cr) - macOS security command-line tool wrapper written by Crystal.

## License

[MIT License](https://github.com/icyleaf/pngdefry.cr/blob/master/LICENSE) © icyleaf