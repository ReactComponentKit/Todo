//
//  Todo.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import Foundation

struct Todo: Equatable {
    let id: String
    var title: String
    var date: Date
    var done: Bool
}
