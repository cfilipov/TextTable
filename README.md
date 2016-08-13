# TextTable

Easily print textual tables in Swift. Inspired by the Python [tabulate](https://pypi.python.org/pypi/tabulate) library.

Latest Version   | 
---------------- |
[1.0.0-alpha.1](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.1) |

## Features

* Easily generate textual tables from collections of any type
* Auto-calculates column width
* Custom width for individual columns
* Align individual columns
* Supports per-column [Formatters](https://developer.apple.com/reference/foundation/nsformatter)
* Multiple table output styles including Markdown, Emacs, HTML, Latex etc...
* Extensible table formatters allow you to easily create your own table format

## Requirements

This package was written for and tested with the following version of Swift:

> Apple Swift version 3.0 (swiftlang-800.0.41.2 clang-800.0.36)

## Usage

Use the [Swift Package Manager](https://swift.org/package-manager/) to install `TextTable` as a dependency of your project.

```Swift
dependencies: [
    .Package(
        url: "https://github.com/cfilipov/TextTable",
        Version(1, 0, 0, prereleaseIdentifiers: ["alpha", "0"]))
]
```

First, import `TextTable`:

```Swift
import TextTable
```

Throughout the examples, the following data structure will be used:

```Swift
private struct Person {
    let name: String
    let age: Int
    let birhtday: Date
}
```

Let's say we have a collection of `Person` we wish to display as a table.

```Swift
let data = [
	Person(name: "Alice", age: 42, birhtday: Date()),
	Person(name: "Bob", age: 22, birhtday: Date()),
	Person(name: "Eve", age: 142, birhtday: Date())
]
```

### Configure a TextTable Instance

Configure a `TextTable` instance for the type you wish to print as a table. The minimum configuration will require a mapping of values to columns for your type.

```Swift
let table = TextTable<Person> { t in
    t.column("Name") { $0.name }
    t.column("Age") { $0.age }
    t.column("Birthday") { $0.birhtday }
}
```

### Simple Uage

Simply call the `print()` method, passing in a collection of `Person`.

```Swift
table.print(data)
```

Output:

```
Name  Age                  Birthday
----- --- -------------------------
Alice  42 2016-08-13 19:21:54 +0000
Bob    22 2016-08-13 19:21:54 +0000
Eve   142 2016-08-13 19:21:54 +0000
```

### Getting a String

You can also just get a string instead of printing it.

```Swift
let s = table.string(for: data)
```

### Customize Table Style

You can optionally specify a table style using the `format` argument.

```Swift
table.print(data, format: Format.Psql())
```

Which result in this:

```
+-------+-----+---------------------------+
| Name  | Age |                  Birthday |
+-------+-----+---------------------------+
| Alice |  42 | 2016-08-13 08:12:58 +0000 |
| Bob   |  22 | 2016-08-13 08:12:58 +0000 |
| Eve   | 142 | 2016-08-13 08:12:58 +0000 |
+-------+-----+---------------------------+
```

The format can also be specified with the `string(for:)` method.

```Swift
let s = table.string(for: data, format: Format.Plain())
```

For a full list of supported formats see [Supported Formats](#supported-formats) below.

### Column-Specific Formatters

You can specify a [Formatter](https://developer.apple.com/reference/foundation/nsformatter) on a per-column basis. In this example a [DateFormatter](https://developer.apple.com/reference/foundation/nsdateformatter) is used to customize the display of the `Birthday` column.

```Swift
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .medium

private let table = TextTable<Person> { t in
    t.column("Name") { $0.name }
    t.column("Age") { $0.age }
    t.column("Birthday") { $0.birhtday }
        .formatter(dateFormatter)
}

table.print(data, format: Format.Psql())
```

Output:

```
+-------+-----+--------------+
| Name  | Age |     Birthday |
+-------+-----+--------------+
| Alice |  42 | Aug 13, 2016 |
| Bob   |  22 | Aug 13, 2016 |
| Eve   | 142 | Aug 13, 2016 |
+-------+-----+--------------+
```

### Column Width

By default TextTable will calculate the necessary width for each column. You can also explictely set the width.

```Swift
let table = TextTable<Person> { t in
    t.column("Name") { $0.name }
        .width(10)
    t.column("Age") { $0.age }
        .width(10)
}

table.print(data, format: Format.Psql())
```

Output:

```
+------------+------------+
| Name       |        Age |
+------------+------------+
| Alice      |         42 |
| Bob        |         22 |
| Eve        |        142 |
+------------+------------+
```

### Column Alignment

By default the first column will be left-aligned and the remaining columns will be right-aligned. You can set the alignment on each column individually.

```Swift
let table = TextTable<Person> { t in
    t.column("Name") { $0.name }
        .align(.right)
    t.column("Age") { $0.age }
}

table.print(data, format: Format.Psql())
```

Output:

```
+-------+-----+
|  Name | Age |
+-------+-----+
| Alice |  42 |
|   Bob |  22 |
|   Eve | 142 |
+-------+-----+
```

## Supported Formats

TextTable supports most of the formats as [tabulate](https://pypi.python.org/pypi/tabulate).

### Plain

```
> table.print(data, format: Format.Plain())

Name  Age Birthday
Alice  42  8/13/16
Bob    22  8/13/16
Eve   142  8/13/16
```

### Simple

`Simple` is the default format. It corresponds to `simple_tables` in [Pandoc](http://pandoc.org/) Markdown extensions.

```
> table.print(data) // or..
> table.print(data, format: Format.Simple())

Name  Age Birthday
----- --- --------
Alice  42  8/13/16
Bob    22  8/13/16
Eve   142  8/13/16
```

### Grid

`Grid` follows the conventions of Emacs’ [table.el package](https://www.emacswiki.org/emacs/TableMode). It corresponds to `grid_tables` in Pandoc Markdown extensions.

```
> table.print(data, format: Format.Grid())

+-------+-----+----------+
| Name  | Age | Birthday |
+=======+=====+==========+
| Alice |  42 |  8/13/16 |
+-------+-----+----------+
| Bob   |  22 |  8/13/16 |
+-------+-----+----------+
| Eve   | 142 |  8/13/16 |
+-------+-----+----------+
```

### FancyGrid

```
> table.print(data, format: Format.FancyGrid())

╒═══════╤═════╤══════════╕
│ Name  | Age | Birthday │
╞═══════╪═════╪══════════╡
│ Alice │  42 │  8/13/16 │
├───────┼─────┼──────────┤
│ Bob   │  22 │  8/13/16 │
├───────┼─────┼──────────┤
│ Eve   │ 142 │  8/13/16 │
╘═══════╧═════╧══════════╛
```

### Psql

```
> table.print(data, format: Format.Psql())

+-------+-----+----------+
| Name  | Age | Birthday |
+-------+-----+----------+
| Alice |  42 |  8/13/16 |
| Bob   |  22 |  8/13/16 |
| Eve   | 142 |  8/13/16 |
+-------+-----+----------+
```

### Pipe

`Pipe` follows the conventions of [PHP Markdown Extra extension](https://michelf.ca/projects/php-markdown/extra/). It corresponds to `pipe_tables` in Pandoc. This format uses colons to indicate column alignment.

```
> table.print(data, format: Format.Pipe())

| Name  | Age | Birthday |
|:------|----:|---------:|
| Alice |  42 |  8/13/16 |
| Bob   |  22 |  8/13/16 |
| Eve   | 142 |  8/13/16 |
```

### Org

`Org` follows the conventions of [Emacs org-mode](http://orgmode.org/).

```
> table.print(data, format: Format.Org())

| Name  | Age | Birthday |
|-------+-----+----------|
| Alice |  42 |  8/13/16 |
| Bob   |  22 |  8/13/16 |
| Eve   | 142 |  8/13/16 |
```

### Rst

`Rst` follows the conventions of simple table of the [reStructuredText](http://docutils.sourceforge.net/rst.html) format.

```
> table.print(data, format: Format.Rst())

===== === ========
Name  Age Birthday
===== === ========
Alice  42  8/13/16
Bob    22  8/13/16
Eve   142  8/13/16
===== === ========
```

### Html

`Html` produces [HTML table](https://www.w3.org/TR/html5/tabular-data.html) markup.

```
> table.print(data, format: Format. Html())

<table>
<tr><th style="text-align:left;">Name</th><th style="text-align:right;">Age</th><th style="text-align:right;">Birthday</th></tr>
<tr><td>Alice</td><td>42</td><td>8/13/16</td></tr>
<tr><td>Bob</td><td>22</td><td>8/13/16</td></tr>
<tr><td>Eve</td><td>142</td><td>8/13/16</td></tr>
</table>
```

### Latex

`Latex` produces a [tabular](https://www.tug.org/TUGboat/tb28-3/tb90hoeppner.pdf) environment for [Latex](https://www.latex-project.org/about/).

```
> table.print(data, format: Format.Latex())

\begin{tabular}{lr}
\hline
 Name & Age & Birthday \\
\hline
 Alice & 42 & 8/13/16 \\
 Bob & 22 & 8/13/16 \\
 Eve & 142 & 8/13/16 \\
\hline
\end{tabular}
```

## Custom Formats

You can create a custom table format by conforming to the `TextTableFormatter` protocol and passing an instance of your custom formatter to the `print()` or `string(for)` methods.

## Changes

A list of changes can be found in the [CHANGELOG](CHANGELOG.md).

## License

MIT License

Copyright (c) 2016 Cristian Filipov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
