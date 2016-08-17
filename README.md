# TextTable

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat-square)](https://swift.org)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://tldrlegal.com/license/mit-license)
[![License MIT](https://img.shields.io/badge/SPM-1.0.0--alpha.4-red.svg?style=flat-square)](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.4)

Easily print textual tables in Swift. Inspired by the Python [tabulate](https://pypi.python.org/pypi/tabulate) library.

## Features

* Easily generate textual tables from collections of any type
* Auto-calculates column width
* Custom width for individual columns
* Align individual columns
* Supports per-column [Formatters](https://developer.apple.com/reference/foundation/nsformatter)
* Multiple table output styles including Markdown, Emacs, HTML, Latex etc...
* Extensible table styles allow you to easily create your own table style
* Column-specific truncation modes (truncate head or tail of column content or optionally fail if content overflows).

## Requirements

This package was written for and tested with the following version of Swift:

> Apple Swift version 3.0 (swiftlang-800.0.43.6 clang-800.0.38)

## Usage

Use the [Swift Package Manager](https://swift.org/package-manager/) to install `TextTable` as a dependency of your project.

```Swift
dependencies: [
    .Package(
        url: "https://github.com/cfilipov/TextTable",
        Version(1, 0, 0, prereleaseIdentifiers: ["alpha", "4"]))
]
```

First, import `TextTable`:

```Swift
import TextTable
```

Throughout the examples, the following data structure will be used:

```Swift
struct Person {
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
let table = TextTable<Person> {
    [Column("Name" <- $0.name),
     Column("Age" <- $0.age),
     Column("Birthday" <- $0.birhtday)]
}
```

#### Alternate Syntax

The `<-` operator is just syntactic sugar. If you don't want to use the operator, you can use labeled arguments instead.

```Swift
let table = TextTable<Person> {
    [Column(title: "Name", value: $0.name),
     Column(title: "Age", value: $0.age),
     Column(title: "Birthday", value: $0.birhtday)]
}
```

### Printing a Table

Simply call the `print()` method, passing in a collection of `Person`.

```Swift
table.print(data)
```
```
Name  Age Birthday
----- --- -------------------------
Alice 42  2016-08-13 19:21:54 +0000
Bob   22  2016-08-13 19:21:54 +0000
Eve   142 2016-08-13 19:21:54 +0000
```

### Getting a String

You can also just get the rendered table as a string by calling the `string(for:)` method.

```Swift
let s = table.string(for: data)
```

### Customize Table Style

You can optionally specify a table style using the `style:` argument.

```Swift
table.print(data, style: Style.psql)
```
```
+-------+-----+---------------------------+
| Name  | Age | Birthday                  |
+-------+-----+---------------------------+
| Alice | 42  | 2016-08-13 08:12:58 +0000 |
| Bob   | 22  | 2016-08-13 08:12:58 +0000 |
| Eve   | 142 | 2016-08-13 08:12:58 +0000 |
+-------+-----+---------------------------+
```

The style can also be specified when using the `string(for:)` method.

```Swift
let s = table.string(for: data, style: Style.psql)
```

For a full list of supported styles see [Supported Styles](#supported-styles) below.

### Column-Specific Formatters

You can specify a [Formatter](https://developer.apple.com/reference/foundation/nsformatter) on a per-column basis. In this example a [DateFormatter](https://developer.apple.com/reference/foundation/nsdateformatter) is used to customize the display of the `Birthday` column.

```Swift
let df = DateFormatter()
dateFormatter.dateStyle = .medium

let table = TextTable<Person> {
    [Column("Name" <- $0.name),
     Column("Age" <- $0.age),
     Column("Birthday" <- $0.birhtday, formatter: df)]
}

table.print(data, style: Style.psql)
```
```
+-------+-----+--------------+
| Name  | Age | Birthday     |
+-------+-----+--------------+
| Alice | 42  | Aug 13, 2016 |
| Bob   | 22  | Aug 13, 2016 |
| Eve   | 142 | Aug 13, 2016 |
+-------+-----+--------------+
```

### Column Width

By default TextTable will calculate the necessary width for each column. You can also explictely set the width with the `width:` argument.

```Swift
let table = TextTable<Person> {
    [Column("Name" <- $0.name, width: 10),
     Column("Age" <- $0.age, width: 10)]
}
	
table.print(data, style: Style.psql)
```
```
+------------+------------+
| Name       | Age        |
+------------+------------+
| Alice      | 42         |
| Bob        | 22         |
| Eve        | 142        |
+------------+------------+
```

#### Note on Padding 

Some table styles may include padding to the left and/or right of the content, the width argument does not effect include this padding.

### Truncation

#### Truncate Tail

By default, if a width is specified and the contents of the column are wider than the width, the text will be truncated at the tail (`.tail` truncation mode).

```Swift
let table = TextTable<Person> { 
	[Column("Name" <- $0.name, width: 4), // defaults to truncation: .tail
	 Column("Age" <- $0.age)]
}

table.print(data, style: testStyle)
```
```
+------+-----+
| Name | Age |
+------+-----+
| Ali… | 42  |
| Bob  | 22  |
| Eve  | 142 |
+------+-----+
```

#### Truncate Head

You can also truncate at the head of the text string by specifying `.head` for the `truncation:` argument. If no `width` argument is present, the `truncation` argument has no effect.

```Swift
let table = TextTable<Person> {
	[Column("Name" <- $0.name, width: 4, truncate: .head),
	 Column("Age" <- $0.age)]
}

table.print(data, style: testStyle)
```
```
+------+-----+
| Name | Age |
+------+-----+
| …ice | 42  |
| Bob  | 22  |
| Eve  | 142 |
+------+-----+
```

#### Truncate Error

If you prefer to have an fatal error triggered when the contents of a column do not fit the specified width you can specify the `.error` truncation mode.

```Swift
let table = TextTable<Person> {
	[Column("Name" <- $0.name, width: 4, truncate: .error),
	 Column("Age" <- $0.age)]
}

table.print(data, style: testStyle)

// fatal error: Truncation error
```

### Column Alignment

By default, all columns will be left-aligned. You can set the alignment on each column individually.

```Swift
let table = TextTable<Person> {
    [Column("Name" <- $0.name), // default: .left
     Column("Age" <- $0.age, align: .right)]
}

table.print(data, style: Style.psql)
```
```
+-------+-----+
| Name  | Age |
+-------+-----+
| Alice |  42 |
| Bob   |  22 |
| Eve   | 142 |
+-------+-----+
```

## Performance Characteristics

By default TextTable will calculate the necessary width for each column that does not specify an explicit width using the `width:` column argument. This calculation is accomplished by iterating over each row of the table twice: the first time to calculate the max width, the second time to actually render the table. The overhead of this calculation may not be appropriate for very large tables. If you wish to avoid this calculation you must specify the width for every column.

In the example below `table1` will incur the overhead of the width calculation because one of the columns does not have an explicit width. On the other hand, `table2` will not incur the overhead because all columns have an explicit width.

```Swift
// This will still result in extra calculations
let table1 = TextTable<Person> {
    [Column("Name" <- $0.name), 
     Column("Age" <- $0.age, width: 10)]
}
```
```Swift
// This will skip the width calculations
let table2 = TextTable<Person> {
    [Column("Name" <- $0.name, width: 9), 
     Column("Age" <- $0.age, width: 10)]
}
```

## Supported Styles

TextTable supports most of the styles as [tabulate](https://pypi.python.org/pypi/tabulate).

### Plain

```
table.print(data, style: Style.plain)
```
```
Name  Age Birthday
Alice  42  8/13/16
Bob    22  8/13/16
Eve   142  8/13/16
```

### Simple

`simple` is the default Style. It corresponds to `simple_tables` in [Pandoc](http://pandoc.org/) Markdown extensions.

```
table.print(data) // or:
table.print(data, style: Style.simple)
```
```
Name  Age Birthday
----- --- --------
Alice  42  8/13/16
Bob    22  8/13/16
Eve   142  8/13/16
```

### Grid

`grid` follows the conventions of Emacs’ [table.el package](https://www.emacswiki.org/emacs/TableMode). It corresponds to `grid_tables` in Pandoc Markdown extensions.

```
table.print(data, style: Style.grid)
```
```
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
table.print(data, style: Style.fancyGrid)
```
```
╒═══════╤═════╤══════════╕
│ Name  │ Age │ Birthday │
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
table.print(data, style: Style.psql)
```
```
+-------+-----+----------+
| Name  | Age | Birthday |
+-------+-----+----------+
| Alice |  42 |  8/13/16 |
| Bob   |  22 |  8/13/16 |
| Eve   | 142 |  8/13/16 |
+-------+-----+----------+
```

### Pipe

`pipe` follows the conventions of [PHP Markdown Extra extension](https://michelf.ca/projects/php-markdown/extra/). It corresponds to `pipe_tables` in Pandoc. This style uses colons to indicate column alignment.

```
table.print(data, style: Style.pipe)
```
```
| Name  | Age | Birthday |
|:------|----:|---------:|
| Alice |  42 |  8/13/16 |
| Bob   |  22 |  8/13/16 |
| Eve   | 142 |  8/13/16 |
```

### Org

`org` follows the conventions of [Emacs org-mode](http://orgmode.org/).

```
table.print(data, style: Style.org)
```
```
| Name  | Age | Birthday |
|-------+-----+----------|
| Alice |  42 |  8/13/16 |
| Bob   |  22 |  8/13/16 |
| Eve   | 142 |  8/13/16 |
```

### Rst

`rst` follows the conventions of simple table of the [reStructuredText](http://docutils.sourceforge.net/rst.html) Style.

```Swift
table.print(data, style: Style.rst)
```
```
===== === ========
Name  Age Birthday
===== === ========
Alice  42  8/13/16
Bob    22  8/13/16
Eve   142  8/13/16
===== === ========
```

### Html

`html` produces [HTML table](https://www.w3.org/TR/html5/tabular-data.html) markup.

```
table.print(data, style: Style.html)
```
```
<table>
    <tr>
        <th style="text-align:left;">Name</th>
        <th style="text-align:center;">Age</th>
        <th style="text-align:right;">Birthday</th>
    </tr>
    <tr>
        <td>Alice</td>
        <td>42</td>
        <td>8/14/16</td>
    </tr>
    <tr>
        <td>Bob</td>
        <td>22</td>
        <td>8/14/16</td>
    </tr>
    <tr>
        <td>Eve</td>
        <td>142</td>
        <td>8/14/16</td>
    </tr>
</table>
```

### Latex

`latex` produces a [tabular](https://www.tug.org/TUGboat/tb28-3/tb90hoeppner.pdf) environment for [Latex](https://www.latex-project.org/about/).

```
table.print(data, style: Style.latex)
```
```
\begin{tabular}{lll}
\hline
 Name & Age & Birthday \\
\hline
 Alice & 42 & 8/13/16 \\
 Bob & 22 & 8/13/16 \\
 Eve & 142 & 8/13/16 \\
\hline
\end{tabular}
```

## Custom Styles

You can create a custom table style by conforming to the `TextTableStyle` protocol.


```Swift
enum MyCustomStyle: TextTableStyle {
    // implement methods from TextTableStyle...
}

extension Style {
    static let custom = MyCustomStyle.self
}

table.print(data, style: Style.custom)
```

## Changes

A list of changes can be found in the [CHANGELOG](CHANGELOG.md).

## Alternatives

Other Swift libraries that serve a similar purpose.

* [SwiftyTextTable](https://github.com/scottrhoyt/SwiftyTextTable)

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
