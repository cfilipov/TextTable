//
//  HTMLFormattests.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import XCTest
@testable import TextTable

private typealias TestFormat = Format.Html

class HtmlFormatTests: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = table.string(for: data, format: TestFormat())
        }
    }

    func testTable() {
        let expectedOutput = "" +
            "<table>\n" +
            "<tr><th style=\"text-align:left;\">Name</th><th style=\"text-align:right;\">Age</th><th style=\"text-align:right;\">Birthday</th></tr>\n" +
            "<tr><td>Alice</td><td>42</td><td>8/13/16</td></tr>\n" +
            "<tr><td>Bob</td><td>22</td><td>8/13/16</td></tr>\n" +
            "<tr><td>Eve</td><td>142</td><td>8/13/16</td></tr>\n" +
            "</table>" +
        ""
        let s = table.string(for: data, format: TestFormat())!
        XCTAssertEqual(s, expectedOutput)
    }
    
}
