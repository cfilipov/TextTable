//
//  HTMLFormat.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

extension Format {
    public class Html: TextTableFormatter {
        public static var requiresWidth: Bool { return false }

        public var string: String = ""
        public var width: Int? = nil
        public var alignment: Alignment? = nil

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
            if alignment != nil || width != nil {
                string.append(" ")
                string.append("style=\"")
                if let alignment = alignment {
                    string.append("text-align:\(alignment.rawValue);")
                }
                string.append("\"")
            }
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
