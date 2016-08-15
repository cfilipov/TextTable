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
    let notes: String
}

internal let alice = Person(name: "Alice", age: 42, birhtday: Date(), notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ultrices a orci quis rhoncus.")
internal let bob = Person(name: "Bob", age: 22, birhtday: Date(), notes: "Nunc varius lectus eget feugiat euismod. Mauris tincidunt turpis a augue varius, bibendum cursus elit venenatis.")
internal let eve = Person(name: "Eve", age: 142, birhtday: Date(), notes: "Etiam quis lectus vestibulum, cursus lectus at, consectetur enim. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.")
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
    t.column("Notes") { $0.notes }
        .width(10)
    t.column("Notes") { $0.notes }
        .width(10, truncate: .head)
    
}
