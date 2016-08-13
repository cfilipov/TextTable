//
//  TestUtil.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation
import TextTable

internal struct Person {
    let name: String
    let age: Int
    let birhtday: Date
}

internal let alice = Person(name: "Alice", age: 42, birhtday: Date())
internal let bob = Person(name: "Bob", age: 22, birhtday: Date())
internal let eve = Person(name: "Eve", age: 142, birhtday: Date())
internal let data = [alice, bob, eve]

internal let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    return dateFormatter
}()

internal let table = TextTable<Person> { t in
    t.column("Name") { $0.name }
    t.column("Age") { $0.age }
        .width(6)
        .align(.center)
    t.column("Birthday") { $0.birhtday }
        .formatter(dateFormatter)
}
