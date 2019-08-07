//
//  String+Padding.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation

internal typealias PaddingFunction = (_ length: Int, _ character: Character) -> String

internal extension String {
    mutating func append(_ c: String, repeat count: Int) {
        append(String(repeating: c, count: count))
    }

    // https://github.com/coryalder/SwiftLeftpad
    func leftpad(length: Int, character: Character = " ") -> String {
        var outString: String = self
        let extraLength = length - outString.count
        var i = 0
        while (i < extraLength) {
            outString.insert(character, at: outString.startIndex)
            i += 1
        }
        return outString
    }

    func rightpad(length: Int, character: Character = " ") -> String {
        return padding(toLength: length, withPad: String(character), startingAt: 0)
    }

    func centerpad(length: Int, character: Character = " ") -> String {
        let leftlen = (length - count)/2 + count
        return leftpad(length: leftlen).rightpad(length: length)
    }

    func replaceAll(_ character: Character) -> String {
        var out = ""
        for _ in (0..<count) {
            out.append(character)
        }
        return out
    }

    func pad(_ align: Alignment, length: Int) -> String {
        let padfunc: PaddingFunction
        switch align {
        case .left: padfunc = rightpad
        case .right: padfunc = leftpad
        case .center: padfunc = centerpad
        }
        return padfunc(length, " ")
    }

    func truncated(_ mode: Truncation, length: Int) -> String {
        switch mode {
        case .tail:
            guard count > length else { return self }
            return self[..<index(startIndex, offsetBy: length-1)] + "…"
        case .head:
            guard count > length else { return self }
            return "…" + self[index(endIndex, offsetBy: -1*(length-1))...]
        case .error:
            guard count <= length else { return self }
            fatalError("Truncation error")
        }
    }
}
