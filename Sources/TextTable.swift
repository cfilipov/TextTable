//
//  TextTablePrintable.swift
//  Stooli
//
//  Created by Cristian Filipov on 8/8/16.
//
//

import Foundation

/**
 Instances of `TextTable` represent the mapping of a type to a tabular representation. That is, `TextTable` defines how a collection of `T` can be transformed into a set of rows and columns along with the corresponding header titles and other attributes.
 
 A `TextTable` is configured inside the closure of the `init` method. Use the `Config` instance passed to the builder closure to add columns to the `TextTable` configuration.
 
 ## Basic Usage
 
     struct Person {
         let name: String
         let age: Int
         let birhtday: Date
     }

     let dateFormatter = DateFormatter()
     dateFormatter.dateStyle = .medium

     let table = TextTable<Person> { t in
         t.column("Name") { $0.name }
         t.column("Age") { $0.age }
             .width(6)
             .align(.center)
         t.column("Birthday") { $0.birhtday }
             .formatter(dateFormatter)
     }
 
     table.print(data)

 Output:

     Name   Age   Birthday
     ----- ------ --------
     Alice   42    8/13/16
     Bob     22    8/13/16
     Eve    142    8/13/16
 */
public final class TextTable<T> {
    public typealias Builder = (Config<T>) -> Void

    private let config: Config<T>

    public init(_ build: Builder) {
        let config = Config<T>()
        build(config)
        self.config = config
    }

    private func widths<C: Collection where C.Iterator.Element == T>(for data: C, columns: [Column<T>], format: TextTableFormatter) -> [Int?] {
        guard format.dynamicType.requiresWidth else {
            return columns.map{$0.width}
        }
        // If all columns have explicitely set width, skip calculation
        let missingWidths = columns.filter{($0.width == nil)}.count
        guard missingWidths > 0 else {
            return columns.map{$0.width}
        }
        var calculatedWidths = config.columns.map{$0.width ?? 0}
        for el in data {
            for (index,column) in config.columns.enumerated() {
                let text = format.text(el, column)
                calculatedWidths[index] = max(text.characters.count, calculatedWidths[index])
            }
        }
        for (index,column) in config.columns.enumerated() {
            if column.width == nil {
                if let title = column.title {
                    calculatedWidths[index] = max(title.characters.count, calculatedWidths[index])
                }
            }
        }
        return calculatedWidths.map(Optional.some)
    }

    /**
     Returns a `String` formatted as textual representation of a table.
     
     Parameters:
     
        - for: A collection of some `T`. Each `T` will be used as row.
        - format: [optional] The format to use when rendering the table. The default is `Format.Simple()`.
     */
    public func string<C: Collection where C.Iterator.Element == T>(for data: C, format: TextTableFormatter = Format.Simple()) -> String? {
        var formatter = format
        let widths = self.widths(for: data, columns: config.columns, format: format)
        formatter.beginTable()
        if config.headerEnabled {
            formatter.beginHeaderRow()
            for (index, column) in config.columns.enumerated() {
                formatter.width = column.width ?? widths[index]
                formatter.align = column.alignment
                formatter.beginHeaderColumn()
                if let title = column.title {
                    formatter.content(title)
                }
                formatter.endHeaderColumn()
            }
            formatter.endHeaderRow()
        }
        for el in data {
            formatter.beginRow()
            for (index, column) in config.columns.enumerated() {
                formatter.width = column.width ?? widths[index]
                formatter.align = column.alignment
                formatter.beginColumn()
                formatter.content(formatter.text(el, column))
                formatter.endColumn()
            }
            formatter.endRow()
        }
        formatter.endTable()
        return formatter.string
    }

    func print<C: Collection where C.Iterator.Element == T>(_ data: C, format: TextTableFormatter = Format.Simple()) {
        if let string = string(for: data, format: format) {
            Swift.print(string)
        }
    }
}

public enum Format {}

public protocol TextTableFormatter {
    static var requiresWidth: Bool { get }

    var string: String { get }
    var width: Int? { get set }
    var align: Alignment { get set }

    static func escape(_ s: String) -> String

    func beginTable()
    func endTable()
    func beginHeaderRow()
    func endHeaderRow()
    func beginRow()
    func endRow()
    func beginHeaderColumn()
    func endHeaderColumn()
    func beginColumn()
    func endColumn()
    func content(_ s: String)
}

public enum Alignment: String {
    case left = "left"
    case right = "right"
    case center = "center"
}

public enum Truncation {
    case head
    case tail
    case error
}

private extension TextTableFormatter {
    private func text<T>(_ element: T, _ column: Column<T>) -> String {
        return Self.escape(truncated(column.text(element), column))
    }

    private func truncated<T>(_ text: String, _ column: Column<T>) -> String {
        guard let width = width else { return text }
        return text.truncated(column.tuncationMode, length: width)
    }
}

/**
 The column configuration of a `TextTable`. Each `Column` instance maps a type `T` to a specific column.
 */
public final class Column<T> {
    public typealias Value = (T) -> Any

    private var title: String? = nil
    private var alignment: Alignment = .right
    private var width: Int? = nil
    private var formatter: Formatter? = nil
    private var tuncationMode: Truncation = .tail
    private var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    private func text(_ el: T) -> String {
        let s = value(el)
        guard let obj = s as? AnyObject else {
            return "\(s)"
        }
        guard let text = formatter?.string(for: obj) else {
            return "\(s)"
        }
        return text
    }

    /**
     Sets the alignment of the column.
     */
    @discardableResult public func align(_ alignment: Alignment) -> Column {
        self.alignment = alignment
        return self
    }

    /**
     Sets the width of the column.
     */
    @discardableResult public func width(_ width: Int, truncate: Truncation = .tail) -> Column {
        self.width = width
        self.tuncationMode = truncate
        return self
    }

    /**
     Sets a `Formatter` to use for formatting the text content of the column.
     */
    @discardableResult public func formatter(_ formatter: Formatter) -> Column {
        self.formatter = formatter
        return self
    }
}

public final class Config<T> {
    private var columns: [Column<T>] = []
    private var headerEnabled: Bool = true

    @discardableResult public func column(_ title: String, _ value: Column<T>.Value) -> Column<T> {
        let column = Column<T>(value)
        column.title = title
        if columns.isEmpty {
            column.alignment = .left
        }
        columns.append(column)
        return column
    }
}
