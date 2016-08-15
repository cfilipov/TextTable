//
//  HTMLFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public final class Html: TextTableFormatter {
        public static var requiresWidth: Bool { return false }

        public var string: String = ""
        public var width: Int? = nil
        public var align: Alignment = .left

        public static func escape(_ s: String) -> String {
            return s
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: "<", with: "&gt;")
        }

        public func beginTable() {
            string.append("<table>\n")
        }

        public func endTable() {
            string.append("</table>")
        }

        public func beginHeaderRow() {
            string.append("<tr>")
        }

        public func endHeaderRow() {
            string.append("</tr>\n")
        }

        public func beginRow() {
            string.append("<tr>")
        }

        public func endRow() {
            string.append("</tr>\n")
        }

        public func beginHeaderColumn() {
            string.append("<")
            string.append("th")
            string.append(" ")
            string.append("style=\"")
            string.append("text-align:\(align.rawValue);")
            string.append("\"")
            string.append(">")
        }

        public func endHeaderColumn() {
            string.append("</th>")
        }

        public func beginColumn() {
            string.append("<td>")
        }

        public func endColumn() {
            string.append("</td>")
        }
        
        public func content(_ s: String) {
            string.append(s)
        }
    }
}
