//
//  LatexFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public final class Latex: TextTableFormatter {
        public static var requiresWidth: Bool { return false }

        public var string: String = ""
        public var width: Int? = nil
        public var align: Alignment = .left

        private var contentStack: [String] = []

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
        
        public func beginTable() {
            string.append("\\begin{tabular}{lr}\n")
        }

        public func endTable() {
            string.append("\\hline\n")
            string.append("\\end{tabular}\n")
        }

        public func beginHeaderRow() {
            string.append("\\hline\n")
        }

        public func endHeaderRow() {
            string.append(" ")
            string.append(contentStack.joined(separator: " & "))
            string.append(" \\\\\n")
            string.append("\\hline\n")
        }

        public func beginRow() {
            contentStack.removeAll()
        }

        public func endRow() {
            string.append(" ")
            string.append(contentStack.joined(separator: " & "))
            string.append(" \\\\\n")
        }

        public func beginHeaderColumn() { }
        public func endHeaderColumn() { }
        public func beginColumn() { }
        public func endColumn() { }

        public func content(_ s: String) {
            contentStack.append(s)
        }
    }
}
