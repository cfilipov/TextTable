//
//  TextTablePrintable.swift
//  Stooli
//
//  Created by Cristian Filipov on 8/8/16.
//
//

import Foundation

infix operator <- : AssignmentPrecedence

public func <- (left: String, right: Any) -> (title: String, value: Any) {
    return (left, right)
}

private func + (left: [Column], right: [Int]) -> [Column] {
    precondition(left.count == right.count)
    return zip(left, right).map { $0.0.settingWidth($0.1) }
}

private func unwrap(_ any: Any) -> Any {
    let m = Mirror(reflecting: any)
    if m.displayStyle != .optional { return any }
    if m.children.count == 0 { return "NULL" }
    let (_, some) = m.children.first!
    return some
}

public enum Alignment {
    case left
    case right
    case center
}

public enum Truncation {
    case tail
    case head
    case error
}

/**
 The style pseudo-namespace groups together all the built-in styles that come siwht TextTable. You can add you own styles by extending the `Style` type.
 */
public enum Style {
    public static let simple = Simple.self
    public static let plain = Plain.self
    public static let rst = Rst.self
    public static let psql = Psql.self
    public static let pipe = Pipe.self
    public static let org = Org.self
    public static let latex = Latex.self
    public static let html = Html.self
    public static let grid = Grid.self
    public static let fancy = FancyGrid.self
}

/**
 A `Column` defines how a particular piece of data will be rendered in the text table.
 */
public struct Column {
    let title: String
    let value: Any
    let width: Int?
    let align: Alignment
    let truncate: Truncation
    let formatter: Formatter?

    public init(title: String, value: Any, width: Int? = nil, align: Alignment = .left, truncate: Truncation = .tail, formatter: Formatter? = nil) {
        self.title = title
        self.value = unwrap(value)
        self.width = width
        self.align = align
        self.truncate = truncate
        self.formatter = formatter
    }

    public init(_ mapping: @autoclosure () -> (String, Any), width: Int? = nil, align: Alignment = .left, truncate: Truncation = .tail, formatter: Formatter? = nil) {
        let (t, v) = mapping()
        self = Column(
            title: t,
            value: v,
            width: width,
            align: align,
            truncate: truncate,
            formatter: formatter)
    }

    internal var resolvedWidth: Int {
        return width ?? title.count
    }

//    private func string(for value: Any) -> String {
//        var string = String(describing: value)
//        if let formatter = formatter {
//            string = formatter.string(for: value) ?? string
//        }
//        return string
//    }

    fileprivate func settingWidth(_ newWidth: Int) -> Column {
        return Column(
            title: self.title,
            value: self.value,
            width: newWidth,
            align: self.align,
            truncate: self.truncate,
            formatter: self.formatter)
    }
}

public extension Column {
    func string(for style: TextTableStyle.Type) -> String {
        var string = ""
        if let formatter = formatter {
            string = formatter.string(for: value) ?? string
        } else {
            string = String(describing: value)
        }
        return style.prepare(string, for: self)
    }

    func headerString(for style: TextTableStyle.Type) -> String {
        return style.prepare(title, for: self)
    }

    func repeated(_ string: String) -> String {
        return String(repeating: string, count: resolvedWidth)
    }
}

/**
 The `TextTableStyle` protocol defines a set of static methods used to render a textual table. Styles are meant to be stateless and re-usable and are not meant to be instantiated. For this reason it is recomended to use case-less enums for your custom styles.
 
 Each static method accepts an inout `String` argument which is to be appended to as the output and an array of columns.
 */
public protocol TextTableStyle {
    /**
     Prepare the string to be rendered. The string may be the header text or column value. Typically this method will pad, truncate and call `escape()` on the string. If no special preperation is required for this style, you can simply return the passed-in string.
     */
    static func prepare(_ s: String, for column: Column) -> String

    /**
     Escape any special characters from the provided string. Most styles simply return the passed-in string. However, in some cases you might want to escape certain characters that have special meaning in your output format. For example, the HTML style will escape `<`, `>` and other reserved HTML characters.
     */
    static func escape(_ table: String) -> String

    /**
     Called before the header or any of the rows.
     */
    static func begin(_ table: inout String, index: Int, columns: [Column])

    /**
     Called after all the rows have completed.
     */
    static func end(_ table: inout String, index: Int, columns: [Column])

    /**
     Called just before the first row.
     */
    static func header(_ table: inout String, index: Int, columns: [Column])

    /**
     Called for each row.
     */
    static func row(_ table: inout String, index: Int, columns: [Column])
}

/**
 `TextTable` formats a string into a textual representation of a table. `TextTable` can render tables in various different styles including HTML, Markdown and Latex tables.

 Instances of `TextTable` represent the mapping of a type to a tabular representation. That is, `TextTable` defines how an instance of `T` can be transformed into a set of columns.
 
 A `TextTable` is configured by returning an array of `Column` instances in the closure argument of the initializer. Each `Column` may specify an width, alignment, truncation mode and NSFormatter. By default, widths are calculated based on the longest content and alignment defaults to left.
 
 ## Basic Usage
 
     struct Person {
         let name: String
         let age: Int
         let birhtday: Date
     }

     let df = DateFormatter()
     dateFormatter.dateStyle = .short

     let table = TextTable<Person> {
         [Column("Name" <- $0.name),
          Column("Age" <- $0.age, width: 6, align: .center),
          Column("Birthday" <- $0.birhtday, formatter: df)]
     }
 
     table.print(data)

 Output:

     Name   Age   Birthday
     ----- ------ --------
     Alice   42    8/13/16
     Bob     22    8/13/16
     Eve    142    8/13/16
 */
public struct TextTable<T> {
    /**
     The adapter function is responsible for mapping an instance `T` to an array of columns. This will be called for each row, including the header. The adapter function may actually be called multiple times for each row or header. You should not make any assumptions regarding the context, order or number of calls.
     */
    public typealias Adapter = (T) -> [Column]

    private let adapter: Adapter

    /**
     Creates an instance of `TextTable` which is used to format strings of tables. This instance represents the mapping of a type `T` to its corresponding columns. An instance can be re-used (and should be re-used unless you need to change the mapping or column configuration).
     */
    public init(_ adapter: @escaping Adapter) {
        self.adapter = adapter
    }

    private func calculateWidths<C: Collection>(for data: C, style: TextTableStyle.Type) -> [Int] where C.Iterator.Element == T {
        guard let first = data.first else { return [] }
        let headerCols = adapter(first)
        var widths = headerCols.map{$0.width ?? 0}
        for (index,column) in headerCols.enumerated() {
            if let w = column.width {
                widths[index] = w
            } else {
                let text = column.headerString(for: style)
                widths[index] = max(text.count, widths[index])
            }
        }
        for element in data {
            let cols = adapter(element)
            for (index, column) in cols.enumerated() {
                if let w = column.width {
                    widths[index] = w
                } else {
                    let text = column.string(for: style)
                    widths[index] = max(text.count, widths[index])
                }
            }
        }
        return widths
    }

    /**
     Returns a string representing the data rendered as a textual table.
     
     - parameter data: A collection of elements `T` for which this `TextTable` instance has been configured.
     - parameter style: The style of table to be rendered. See `Style` for more options.
     */
    public func string<C: Collection>(for data: C, style: TextTableStyle.Type = Style.simple) -> String? where C.Iterator.Element == T {
        guard let first = data.first else { return nil }
        var table = ""
        let cols = adapter(first)
        var widths = cols.compactMap{$0.width}
        if widths.count < cols.count {
            widths = calculateWidths(for: data, style: style)
        }
        style.begin(&table, index: -1, columns: cols + widths)
        style.header(&table, index: -1, columns: cols + widths)
        for (index, element) in data.enumerated() {
            style.row(&table, index: index, columns: adapter(element) + widths)
        }
        style.end(&table, index: -1, columns: cols + widths)
        return table
    }

    /**
     Prints the data rendered as a textual table.
     
     - parameter data: A collection of elements `T` for which this `TextTable` instance has been configured.
     - parameter style: The style of table to be rendered. See `Style` for more options.
     */
    public func print<C: Collection>(_ data: C, style: TextTableStyle.Type = Style.simple) where C.Iterator.Element == T {
        if let table = string(for: data, style: style) {
            Swift.print(table)
        }
    }
}
