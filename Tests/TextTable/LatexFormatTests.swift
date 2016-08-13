//
//  LatexFormatTests.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import XCTest
@testable import TextTable

private typealias TestFormat = Format.Latex

class LatexFormatTests: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = table.string(for: data, format: TestFormat())
        }
    }

    func testTable() {
        let expectedOutput = "" +
            "\\begin{tabular}{lr}\n" +
            "\\hline\n" +
            " Name & Age & Birthday \\\\\n" +
            "\\hline\n" +
            " Alice & 42 & 8/13/16 \\\\\n" +
            " Bob & 22 & 8/13/16 \\\\\n" +
            " Eve & 142 & 8/13/16 \\\\\n" +
            "\\hline\n" +
            "\\end{tabular}\n" +
        ""
        let s = table.string(for: data, format: TestFormat())!
        XCTAssertEqual(s, expectedOutput)
    }
    
}

