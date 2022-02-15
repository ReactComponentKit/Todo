//
//  InMemory.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//
//  Implement for testing
//
import Foundation

class InMemoryRepository: Repository {
    private var todos: [Todo] = [
//        Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "", date: Date(), done: false),
//        Todo(id: UUID().hashValue, title: "영화 보기", content: "", date: Date(), done: false),
//        Todo(id: UUID().hashValue, title: "학원 가기", content: "", date: Date(), done: false),
//        Todo(id: UUID().hashValue, title: "우유 사기", content: "", date: Date(), done: false),
    ]
    
    func loadTodoList() async -> [Todo] {
        return todos
    }
    
    func insert(todo: Todo) async throws {
        let satify = todos.allSatisfy { it in
           it.id != todo.id
        }
        if !satify {
            throw RepositoryError.duplicatedItem
        }
        todos.append(todo)
    }
    
    func delete(todo: Todo) async throws {
        todos.removeAll { $0.id == todo.id }
    }
    
    func update(todo: Todo) async throws {
        let index = todos.firstIndex { it in
            return it.id == todo.id
        }
        if let index = index {
            todos[index] = todo
        } else {
            throw RepositoryError.notExistTodo
        }
    }
    
    func deleteAll() async throws {
        todos = []
    }
}
