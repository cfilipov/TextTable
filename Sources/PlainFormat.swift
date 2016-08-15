//
//  PlainFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public final class Plain: TextTableFormatter {
        public static var requiresWidth: Bool { return true }

        public var string: String = ""
        public var width: Int? = nil
        public var align: Alignment = .left

        private var contentStack: [String] = []

        public static func escape(_ s: String) -> String {
            return s
        }
        
        public func beginTable() { }
        public func endTable() { }
        public func beginHeaderRow() { }

        public func endHeaderRow() {
            string.append(contentStack.joined(separator: " "))
            string.append("\n")
            contentStack.removeAll()
        }

        public func beginRow() { }

        public func endRow() {
            string.append(contentStack.joined(separator: " "))
            string.append("\n")
            contentStack.removeAll()
        }

        public func beginHeaderColumn() { }
        public func endHeaderColumn() { }
        public func beginColumn() { }
        public func endColumn() { }

        public func content(_ s: String) {
            if let width = width {
                contentStack.append(s.pad(align, length: width))
            } else {
                contentStack.append(s)
            }
        }
    }
}
