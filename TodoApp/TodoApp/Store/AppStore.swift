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
    
    @Published
    var didFinishAddTodo: Bool? = nil
    
    let todoList: TodoListStore
    let todoAdd: TodoAddStore

    private init(repository: Repository) {
        self.todoList = TodoListStore(repository: repository)
        self.todoAdd = TodoAddStore(repository: repository)
        super.init(state: AppState())
        self.todoAdd.$didFinishAddTodo.assign(to: &$didFinishAddTodo)
    }
    
    func addNewTodoAction(title: String, content: String, date: Date) async {
        let todo = Todo(id: UUID().hashValue, title: title, content: content, date: date, done: false)
        await todoAdd.insertTodoAction(todo: todo)
        await todoList.loadTodoListAction()
    }
}
