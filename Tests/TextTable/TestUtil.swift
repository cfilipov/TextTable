//
//  TestUtil.swift
//  TextTable
//
//  Created by Cristian Filipov on 8/13/16.
//
//

import Foundation
import TextTable

struct Person {
    let name: String
    let age: Int
    let birhtday: Date
    let notes: String
}

let df: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    return dateFormatter
}()

let data = [
    Person(
        name: "Alice",
        age: 42,
        birhtday: df.date(from: "8/14/2016")!,
        notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ultrices a orci quis rhoncus."),
    Person(
        name: "Bob",
        age: 22,
        birhtday: df.date(from: "8/14/2016")!,
        notes: "Nunc varius lectus eget feugiat euismod. Mauris tincidunt turpis a augue varius, bibendum cursus elit venenatis."),
    Person(
        name: "Eve",
        age: 142,
        birhtday: df.date(from: "8/14/2016")!,
        notes: "Etiam quis lectus vestibulum, cursus lectus at, consectetur enim. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.")
]

let table = TextTable<Person> { person in
    [Column("Name"     <- person.name),
     Column("Age"      <- person.age,      width: 6, align: .center),
     Column("Birthday" <- person.birhtday, align: .right, formatter: df),
     Column("Notes"    <- person.notes,    width: 10, align: .right),
     Column("Notes"    <- person.notes,    width: 10, align: .right, truncate: .head)]
}
