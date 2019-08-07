//
//  GrigFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

public enum Grid: TextTableStyle {
    public static func prepare(_ s: String, for column: Column) -> String {
        var string = s
        if let width = column.width {
            string = string.truncated(column.truncate, length: width)
            string = string.pad(column.align, length: width)
        }
        return escape(string)
    }
    
    public static func escape(_ s: String) -> String { return s }

    private static func line(_ table: inout String, columns: [Column]) {
        table += "+-"
        table += columns.map{$0.repeated("-")}.joined(separator: "-+-")
        table += "-+"
        table += "\n"
    }

    public static func begin(_ table: inout String, index: Int, columns: [Column]) { }
    public static func end(_ table: inout String, index: Int, columns: [Column]) { }

    public static func header(_ table: inout String, index: Int, columns: [Column]) {
        line(&table, columns: columns)

        table += "| "
        table += columns.map{$0.headerString(for: self)}.joined(separator: " | ")
        table += " |"
        table += "\n"

        table += "+="
        table += columns.map{$0.repeated("=")}.joined(separator: "=+=")
        table += "=+"
        table += "\n"
    }

    public static func row(_ table: inout String, index: Int, columns: [Column]) {
        table += "| "
        table += columns.map{$0.string(for: self)}.joined(separator: " | ")
        table += " |"
        table += "\n"
        line(&table, columns: columns)
    }
}
