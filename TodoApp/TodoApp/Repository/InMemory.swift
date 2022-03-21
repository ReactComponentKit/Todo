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
    private var todos = [
        Todo(id: UUID().hashValue, title: "슈퍼마켓 가기", content: "두부를 사자. 그리고 과자를 사자. 해물탕을 먹을거니깐 조개와 생성을 사자. 음료수도 사자.", date: Date(), done: false),
        Todo(id: UUID().hashValue, title: "영화 보기", content: "이터널스를 보자.", date: Date(), done: false),
        Todo(id: UUID().hashValue, title: "학원 가기", content: "영어를 공부하자.", date: Date(), done: false),
        Todo(id: UUID().hashValue, title: "우유 사기", content: "2개를 사자.", date: Date(), done: false),
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
