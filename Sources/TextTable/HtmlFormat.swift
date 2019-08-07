//
//  HTMLFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

public enum Html: TextTableStyle {
    public static func prepare(_ s: String, for column: Column) -> String {
        var string = s
        if let width = column.width {
            string = string.truncated(column.truncate, length: width)
        }
        return escape(string)
    }

    public static func escape(_ s: String) -> String {
        return s
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: "<", with: "&gt;")
    }

    private static func string(for alignment: Alignment) -> String {
        switch alignment {
        case .left: return "left"
        case .right: return "right"
        case .center: return "center"
        }
    }

    private static func string(header col: Column) -> String {
        return "        <th style=\"text-align:\(string(for: col.align));\">" +
            col.headerString(for: self) + "</th>\n"
    }

    private static func string(row col: Column) -> String {
        return "        <td>" + col.string(for: self) + "</td>\n"
    }

    public static func begin(_ table: inout String, index: Int, columns: [Column]) {
        table += "<table>\n"
    }

    public static func end(_ table: inout String, index: Int, columns: [Column]) {
        table += "</table>\n"
    }

    public static func header(_ table: inout String, index: Int, columns: [Column]) {
        table += "    <tr>\n"
        for col in columns {
            table += string(header: col)
        }
        table += "    </tr>\n"
    }

    public static func row(_ table: inout String, index: Int, columns: [Column]) {
        table += "    <tr>\n"
        for col in columns {
            table += string(row: col)
        }
        table += "    </tr>\n"
    }
}
