# TODO

* [ ] Support head/tail truncation without ellipsis.
* [ ] Columns without title. This can be done now by doing `Column("" <- $.foo)`, but this is hacky. It should be possible to do this: `Column($foo)`.
* [ ] Header-less tables. Not all styles may support this.
* [ ] Table footers. Not all styles can support this, but in those cases the data can simply be ignored.
* [ ] Profile performance. Don't know if it's fast or slow right now. Memory usage should be OK and it shouldn't be too bad, but string utils were written naively. 
* [ ] `maxWidth:` column argument. Unlike `width:`, this won't prevent width calculations, but instead it will limit how wide a column can get. If the contents of the column are less than the max width argument the column will be as wide as the calculated width.
* [ ] Better escaping. Right now only Latex and HTML styles escape the contents of the table. Markdown and others probably need this too.
* [ ] Customize `NULL` output. Currently, if an optional column value is `nil`, the column will read `NULL`. This should be configurable.