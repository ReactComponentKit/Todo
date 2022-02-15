//
//  AppStore.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import Foundation
import Redux

struct AppState: State {
    
}

class AppStore: Store<AppState> {
    static let shared = AppStore(repository: InMemoryRepository())
    
    let todoList: TodoListStore

    private init(repository: Repository) {
        self.todoList = TodoListStore(repository: repository)
        super.init(state: AppState())
    }
}
