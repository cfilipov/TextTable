# Change Log

## [1.0.0-alpha.3](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.3)

* **This release contains breaking changes to the API**. This should hopefully be the last major breaking change to the API for a long time.
* `TextTable<T>` construction closure now takes an instance of `T` instead of a `Config<T>`. `Config<T>` has been removed completely. Instead of calling `column(...)` on a `Config<T>` in the closure, you now return an array of `Column` instances. See example transition below for details.
* **Fixed**: Missing/broken tests.
* **Fixed**: Latex `tabular` environment contains incorrect alignments.
* **Fixed**: Handle optional values in mapping.
* **Fixed**: `FancyGrid` using pipe symbol instead of unicode drawing character for header separator.
* All columns are now left-aligned by default (instead of right-aligning the first column by default).
* `TextTableFormatter` has been renamed to `TextTableStyle` to avoid confusion with the Foundation [Formatters](https://developer.apple.com/reference/foundation/nsformatter) class. All references to the word "format" when referring to the type of table rendered have bee changed to "style".
* The `TextTableStyle` protocol (formerly `TextTableFormatter `) is now simplified. All methods in `TextTableStyle` are now static, no state is maintained in `TextTableStyle`. The methods have also been consolidated (`row` instead of `beginRow`, `endRow`, `content`, `beginColumn`, etc...).
* `TextTable<T>` and all the internal types are now value types instead of classes.
* All built-in styles are case-less `enums` so they cannot be accidentally instantiated.

### Known Issues in 1.0.0-alpha.3

* Very little effort has but put into performance optimizations. String utilities in particular.
* It should be possible to create columns without headers, but this hasn't been tested and likely doesn't work yet.

### Transitioning to 1.0.0-alpha.3

Before:

```Swift
let table = TextTable<Person> { t in
    t.column("Name") { $0.name }
    t.column("Age") { $0.age }
    t.column("Birthday") { $0.birhtday }
}
```

After:

```Swift
let table = TextTable<Person> {
    [Column("Name" <- $0.name),
     Column("Age" <- $0.age),
     Column("Birthday" <- $0.birhtday)]
}
```

## [1.0.0-alpha.2](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.2)

* Column truncation support. There is now an optional `truncate:` argument to `width`.
* Added some documentation.

### Known Issues in 1.0.0-alpha.2

* Very little effort has but put into performance optimizations.
* It should be possible to create columns without headers, but this hasn't been tested and likely doesn't work yet.

## [1.0.0-alpha.1](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.1)

* Support for center alignment.
* If all columns have explicit width, then width calculations are skipped.
* Escape strings in certain formats (HTML & Latex, for example).
* Fixed: `TextTable` config persists calculated column widths. This results in widths getting stuck from the first call to `print` or `string(for:)`.

### Known Issues in 1.0.0-alpha.1

* Very little effort has but put into performance optimizations.
* It should be possible to create columns without headers, but this hasn't been tested and likely doesn't work yet.

## [1.0.0-alpha.0](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.0)

* Breaking change: completely re-written API. No more conforming to a protocol, instead a `TextTable` class is used in a similar way to `NSFormatter`. This offers much more flexibility.
* Many more output formats. Similar to what you get from Python's [tabulate](https://pypi.python.org/pypi/tabulate) lib.

### Known Issues in 1.0.0-alpha.0

* No attempt at optimizing performance has been made yet. Even when widths are provided, an expensive calculation is still performed.
* No escaping is being done. None of the formatters even attempt to sanitize the input strings.
* Center alignment not supported. This will result in a `fatalError()`.
* It should be possible to create columns without headers, but this hasn't been tested and likely doesn't work yet.

## [0.0.0](https://github.com/cfilipov/TextTable/releases/tag/v0.0.0)

Initial release. 
