//
//  LatexFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public class Latex: TextTableFormatter {
        public static var requiresWidth: Bool { return false }

        public var string: String = ""
        public var width: Int? = nil
        public var alignment: Alignment? = nil

        private var contentStack: [String] = []

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
            let pad: PaddingFunction
            switch alignment {
            case .some(.left): pad = s.rightpad
            case .some(.right): pad = s.leftpad
            case .some(.center): fatalError()
            case .none: pad = s.leftpad
            }
            if let width = width {
                contentStack.append(pad(length: width, character: " "))
            } else {
                contentStack.append(s)
            }
        }
    }
}
