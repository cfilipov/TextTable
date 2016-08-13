//
//  SimpleFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public class Simple: TextTableFormatter {
        public static var requiresWidth: Bool { return true }

        public var string: String = ""
        public var width: Int? = nil
        public var alignment: Alignment? = nil

        private var contentStack: [String] = []

        public func beginTable() { }
        public func endTable() { }
        public func beginHeaderRow() { }

        public func endHeaderRow() {
            string.append(contentStack.joined(separator: " "))
            string.append("\n")
            string.append(contentStack
                .map{$0.replaceAll("-")}
                .joined(separator: " "))
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
