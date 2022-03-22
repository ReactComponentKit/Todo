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
    static let shared = AppStore(repository: LocalDBRepository())
    
    @Published
    var didFinishAddTodo: Bool? = nil
    
    @Published
    var didFinishUpdateTodo: Bool? = nil
    
    let todoList: TodoListStore
    let todoAdd: TodoAddStore
    let todoDetail: TodoDetailStore

    private init(repository: Repository) {
        self.todoList = TodoListStore(repository: repository)
        self.todoAdd = TodoAddStore(repository: repository)
        self.todoDetail = TodoDetailStore(repository: repository)
        super.init(state: AppState())
        self.todoAdd.$didFinishAddTodo.assign(to: &$didFinishAddTodo)
        self.todoDetail.$didFinishUpdateTodo.assign(to: &$didFinishUpdateTodo)
    }
    
    func addNewTodoAction(title: String, content: String, date: Date) async {
        let todo = Todo(id: UUID().hashValue, title: title, content: content, date: date, done: false)
        await todoAdd.insertTodoAction(todo: todo)
        await todoList.loadTodoListAction()
    }
    
    func updateTodoAction(todo: Todo) async {
        await todoDetail.update(todo: todo)
        await todoList.loadTodoListAction()
    }
}
