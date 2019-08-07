//
//  LatexFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

public enum Latex: TextTableStyle {
    public static func prepare(_ s: String, for column: Column) -> String {
        var string = s
        if let width = column.width {
            string = string.truncated(column.truncate, length: width)
            string = string.pad(column.align, length: width)
        }
        return escape(string)
    }

    public static func escape(_ s: String) -> String {
        return s
            .replacingOccurrences(of: "#", with: "\\#")
            .replacingOccurrences(of: "$", with: "\\$")
            .replacingOccurrences(of: "%", with: "\\%")
            .replacingOccurrences(of: "&", with: "\\&")
            .replacingOccurrences(of: "\\", with: "\\textbackslash{}")
            .replacingOccurrences(of: "^", with: "\\textasciicircum{}")
            .replacingOccurrences(of: "_", with: "\\_")
            .replacingOccurrences(of: "{", with: "\\{")
            .replacingOccurrences(of: "}", with: "\\}")
            .replacingOccurrences(of: "~", with: "\\textasciitilde{}")
            // not strictly necessary, but makes for nicer output
            .replacingOccurrences(of: "…", with: "\\ldots ")
    }

    private static func alignments(_ col: Column) -> String {
        switch col.align {
        case .left: return "l"
        case .right: return "r"
        case .center: return "c"
        }
    }

    public static func begin(_ table: inout String, index: Int, columns: [Column]) {
        let align = columns.map(alignments).joined(separator: "")
        table += "\\begin{tabular}{\(align)}\n"
    }

    public static func end(_ table: inout String, index: Int, columns: [Column]) {
        table += "\\hline\n"
        table += "\\end{tabular}\n"
    }

    public static func header(_ table: inout String, index: Int, columns: [Column]) {
        table += "\\hline\n"
        table += " "
        table += columns.map{$0.headerString(for: self)}.joined(separator: " & ")
        table += " \\\\\n"
        table += "\\hline\n"
    }

    public static func row(_ table: inout String, index: Int, columns: [Column]) {
        table += " "
        table += columns.map{$0.string(for: self)}.joined(separator: " & ")
        table += " \\\\\n"
    }
}
