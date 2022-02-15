//
//  LocalDB.swift
//  TodoApp
//
//  Created by burt on 2022/02/15.
//

import Foundation

class LocalDBRepository: Repository {
    func loadTodoList() async throws -> [Todo] {
        return []
    }
    
    func insert(todo: Todo) async throws {
        
    }
    
    func delete(todo: Todo) async throws {
        
    }
    
    func update(todo: Todo) async throws {
        
    }
}
