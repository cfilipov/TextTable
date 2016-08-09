//
//  TextTablePrintable.swift
//  Stooli
//
//  Created by Cristian Filipov on 8/8/16.
//
//

import Foundation

public protocol TextTablePrintable {
    var header: [String] { get }
    var row: [String] { get }
}

// https://github.com/coryalder/SwiftLeftpad
extension String {
    private func leftpad(length: Int, character: Character = " ") -> String {
        var outString: String = self
        let extraLength = length - outString.characters.count
        var i = 0
        while (i < extraLength) {
            outString.insert(character, at: outString.startIndex)
            i += 1
        }
        return outString
    }
}

// https://gist.github.com/JadenGeller/ca466c6ccc96a92ca5c5
extension Sequence {
    private func reduce(combine: @noescape (Iterator.Element, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
        var iterator = makeIterator()
        guard var result = iterator.next() else { return nil }
        while let element = iterator.next() {
            result = try combine(result, element)
        }
        return result
    }
}

public func print<T: Collection where T.Iterator.Element: TextTablePrintable>(table: T) {
    func maxWidths(_ a: [Int], _ b: [Int]) -> [Int] {
        precondition(a.count == b.count)
        return zip(a,b).map(max)
    }
    func width(_ s: String) -> Int {
        return Int(s.characters.count)
    }
    func pad(_ s: String, _ len: Int) -> String {
        return s.leftpad(
            length: len,
            character: " ")
    }
    func print(row: [String], widths: [Int], separator: String) {
        precondition(row.count == widths.count)
        Swift.print(zip(row, widths)
            .map(pad)
            .joined(separator: separator))
    }
    func maxWidths(_ data: T) -> [Int] {
        return data.lazy
            .map{$0.row.map(width)}
            .reduce(combine: maxWidths)!
    }
    func repeated(_ s: Character) -> (Int) -> String {
        return { count in
            String(repeating: s, count: count)
        }
    }

    let header = table.first!.header
    let widths = maxWidths(maxWidths(table), header.map(width))
    let headerSep = widths.map(repeated("-"))
    print(row: header, widths: widths, separator: " | ")
    print(row: headerSep, widths: widths, separator: "-+-")
    for element in table {
        print(row: element.row, widths: widths, separator: " | ")
    }
}
