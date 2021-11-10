//
//  Repository.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import Foundation

enum RepositoryError: Error {
    case none
    case duplicatedItem
    case notExistTodo
}

protocol Repository {
    func loadTodoList() async throws -> [Todo]
    func insert(todo: Todo) async throws
    func delete(todo: Todo) async throws
    func update(todo: Todo) async throws
}
