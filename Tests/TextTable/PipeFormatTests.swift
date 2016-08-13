//
//  PipeFormatTests.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import XCTest
@testable import TextTable

private typealias TestFormat = Format.Pipe

class PipeFormatTests: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = table.string(for: data, format: TestFormat())
        }
    }

    func testTable() {
        let expectedOutput = "" +
            "| Name  | Age | Birthday |\n" +
            "|:------|----:|---------:|\n" +
            "| Alice |  42 |  8/13/16 |\n" +
            "| Bob   |  22 |  8/13/16 |\n" +
            "| Eve   | 142 |  8/13/16 |\n" +
        ""
        let s = table.string(for: data, format: TestFormat())!
        XCTAssertEqual(s, expectedOutput)
    }
    
}
