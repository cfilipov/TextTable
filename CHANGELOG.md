# Change Log

## [1.0.0-alpha.0](https://github.com/cfilipov/TextTable/releases/tag/v1.0.0-alpha.0)

* Breaking change: completely re-written API. No more conforming to a protocol, instead a `TextTable` class is used in similar to `NSFormatter`. This offers much more flexibility.
* Many more output formats. Similar to what you get from Python's [tabulate](https://pypi.python.org/pypi/tabulate) lib.

### Known Issues in 1.0.0-alpha.0

* No attempt at optimizing performance has been made yet. Even when widths are provided, an expensive calculation is still performed.
* No escaping is being done. None of the formatters even attempt to sanitize the input strings.
* Center alignment not supported. This will result in a `fatalError()`.
* It should be possible to create columns without headers, but this hasn't been tested and likely doesn't work yet.

## [0.0.0](https://github.com/cfilipov/TextTable/releases/tag/v0.0.0)

Initial release. 
