//
//  Todo.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import Foundation

struct Todo: Equatable, Hashable {
    var id: Int = 0
    var title: String = ""
    var content: String = ""
    var date: Date = Date()
    var done: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(content)
        hasher.combine(date)
        hasher.combine(done)
    }
}
