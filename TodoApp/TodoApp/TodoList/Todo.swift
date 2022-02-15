//
//  Todo.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import Foundation

struct Todo: Equatable {
    let id: Int
    var title: String
    var content: String
    var date: Date
    var done: Bool
}
