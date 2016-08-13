//
//  TextTablePrintable.swift
//  Stooli
//
//  Created by Cristian Filipov on 8/8/16.
//
//

import Foundation

public class TextTable<T> {
    public typealias Builder = (Config<T>) -> Void

    private let config: Config<T>

    public init(_ build: Builder) {
        let config = Config<T>()
        build(config)
        self.config = config
    }

    public func string<C: Collection where C.Iterator.Element == T>(for data: C, format: TextTableFormatter = Format.Simple()) -> String? {
        var formatter = format
        if formatter.dynamicType.requiresWidth {
            var widths = config.columns.map{$0.width ?? 0}
            for el in data {
                for (index,column) in config.columns.enumerated() {
                    let text = column.text(forElement: el)
                    widths[index] = max(text.characters.count, widths[index])
                }
            }
            for (index,column) in config.columns.enumerated() {
                if column.width == nil {
                    if let title = column.title {
                        column.width = max(title.characters.count, widths[index])
                    } else {
                        column.width = widths[index]
                    }
                }
            }
        }
        formatter.beginTable()
        if config.headerEnabled {
            formatter.beginHeaderRow()
            for column in config.columns {
                formatter.width = column.width
                formatter.alignment = column.alignment
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
            for column in config.columns {
                formatter.width = column.width
                formatter.alignment = column.alignment
                formatter.beginColumn()
                formatter.content(column.text(forElement: el))
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
    var alignment: Alignment? { get set }

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

public class Column<T> {
    public typealias Value = (T) -> Any

    private var title: String? = nil
    private var alignment: Alignment = .right
    private var width: Int? = nil
    private var formatter: Formatter? = nil
    private var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    private func text(forElement el: T) -> String {
        let s = value(el)
        guard let obj = s as? AnyObject else {
            return "\(s)"
        }
        guard let text = formatter?.string(for: obj) else {
            return "\(s)"
        }
        return text
    }

    @discardableResult public func align(_ alignment: Alignment) -> Column {
        self.alignment = alignment
        return self
    }

    @discardableResult public func width(_ width: Int) -> Column {
        self.width = width
        return self
    }

    @discardableResult public func formatter(_ formatter: Formatter) -> Column {
        self.formatter = formatter
        return self
    }
}

public class Config<T> {
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
