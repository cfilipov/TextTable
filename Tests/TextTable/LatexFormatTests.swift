//
//  LatexFormatTests.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import XCTest
@testable import TextTable

private let testStyle = Style.latex

class LatexFormatTests: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = table.string(for: data, style: testStyle)
        }
    }

    func testTable() {
        let expectedOutput = "" +
            "\\begin{tabular}{lcrrr}\n" +
            "\\hline\n" +
            " Name  &  Age   & Birthday &      Notes &      Notes \\\\\n" +
            "\\hline\n" +
            " Alice &   42   &  8/14/16 & Lorem ips\\ldots  & \\ldots  rhoncus. \\\\\n" +
            " Bob   &   22   &  8/14/16 & Nunc vari\\ldots  & \\ldots enenatis. \\\\\n" +
            " Eve   &  142   &  8/14/16 & Etiam qui\\ldots  & \\ldots ulus mus. \\\\\n" +
            "\\hline\n" +
            "\\end{tabular}\n" +
        ""
        let s = table.string(for: data, style: testStyle)!
        XCTAssertEqual(s, expectedOutput)
    }
    
}

