# TextTable

Easily print ASCII tables in Swift.

## Usage

Import `TextTable`:

```Swift
import TextTable
```

Conform to `TextTablePrintable`:

```Swift
struct Foo {
    let id: Int
    let name: String
    let age: Int
}

extension Foo: TextTablePrintable {
    var header: [String] {
        return ["id", "name", "age"]
    }

    var row: [String] {
        return ["\(id)", name, "\(age)"]
    }
}
```

Call `print(table: ...)`:

```Swift
let data = [
    Foo(id: 0, name: "Alice", age: 23),
    Foo(id: 1, name: "Bob", age: 42),
    Foo(id: 2, name: "Eve", age: 113)
]

print(table: data)
```

Output:

```
id |  name | age
---+-------+----
 0 | Alice |  23
 1 |   Bob |  42
 2 |   Eve | 113
```

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
