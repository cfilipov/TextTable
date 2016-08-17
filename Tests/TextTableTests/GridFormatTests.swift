//
//  GridFormatTests.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import XCTest
@testable import TextTable

private let testStyle = Style.grid

class GridFormatTests: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = table.string(for: data, style: testStyle)
        }
    }

    func testTable() {
        let expectedOutput = "" +
            "+-------+--------+----------+------------+------------+\n" +
            "| Name  |  Age   | Birthday |      Notes |      Notes |\n" +
            "+=======+========+==========+============+============+\n" +
            "| Alice |   42   |  8/14/16 | Lorem ips… | … rhoncus. |\n" +
            "+-------+--------+----------+------------+------------+\n" +
            "| Bob   |   22   |  8/14/16 | Nunc vari… | …enenatis. |\n" +
            "+-------+--------+----------+------------+------------+\n" +
            "| Eve   |  142   |  8/14/16 | Etiam qui… | …ulus mus. |\n" +
            "+-------+--------+----------+------------+------------+\n" +
        ""
        let s = table.string(for: data, style: testStyle)!
        XCTAssertEqual(s, expectedOutput)
    }
    
}
