//
//  PipeFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public final class Pipe: TextTableFormatter {
        public static var requiresWidth: Bool { return true }

        public var string: String = ""
        public var width: Int? = nil
        public var align: Alignment = .left

        private var isHeader: Bool = false
        private var contentStack: [String] = []
        private var headerStack: [String] = []

        public static func escape(_ s: String) -> String {
            return s
        }
        
        public func beginTable() { }
        public func endTable() { }

        public func beginHeaderRow() {
            isHeader = true
        }

        public func endHeaderRow() {
            string.append("| ")
            string.append(contentStack.joined(separator: " | "))
            string.append(" |")
            string.append("\n")
            string.append("|")
            string.append(headerStack.joined(separator: "|"))
            string.append("|")
            string.append("\n")
            contentStack.removeAll()
            headerStack.removeAll()
            isHeader = false
        }

        public func beginRow() {
            contentStack.removeAll()
        }

        public func endRow() {
            string.append("| ")
            string.append(contentStack.joined(separator: " | "))
            string.append(" |")
            string.append("\n")
        }

        public func beginHeaderColumn() { }
        public func endHeaderColumn() { }
        public func beginColumn() { }
        public func endColumn() { }

        public func content(_ s: String) {
            let w = max(width!, 3)
            contentStack.append(s.pad(align, length: w))
            if isHeader {
                switch align {
                case .left:
                    headerStack.append(":" + String(repeating: Character("-"), count: w+1))
                case .right:
                    headerStack.append(String(repeating: Character("-"), count: w+1) + ":")
                case .center:
                    headerStack.append(":" + String(repeating: Character("-"), count: w) + ":")
                }
            }
        }
    }
}
