//
//  TodoListStore.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import Foundation
import Redux

struct TodoListState: State {
    var todoList: [Todo] = []
    var error: RepositoryError = .none
}

class TodoListStore: Store<TodoListState> {
    private let repository: Repository
    init(repository: Repository) {
        self.repository = repository
        super.init(state: TodoListState())
    }
    
    @Published
    var todoList: [Todo] = []
    
    override func computed(new: TodoListState, old: TodoListState) {
        self.todoList = new.todoList
    }
    
    private func SET_TODO_LIST(state: inout TodoListState, payload: [Todo]) {
        state.todoList = payload
    }
    
    private func SET_ERROR(state: inout TodoListState, payload: RepositoryError) {
        state.error = payload
    }
    
    func loadTodoListAction() async {
        do {
            let result = try await repository.loadTodoList()
            commit(mutation: SET_TODO_LIST, payload: result)
        } catch {
            commit(mutation: SET_TODO_LIST, payload: [])
        }
    }
    
    func insertTodoAction(todo: Todo) async {
        do {
            try await repository.insert(todo: todo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
    
    func deleteTodoAction(todo: Todo) async {
        do {
            try await repository.delete(todo: todo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
    
    func doneTodoAction(todo: Todo) async {
        do {
            var mutatedTodo = todo
            mutatedTodo.done = true
            try await repository.update(todo: mutatedTodo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
    
    func reopenTodoAction(todo: Todo) async {
        do {
            var mutatedTodo = todo
            mutatedTodo.done = false;
            try await repository.update(todo: mutatedTodo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
    
    func change(todo: Todo, withTitle title: String) async {
        do {
            var mutatedTodo = todo
            mutatedTodo.title = title
            try await repository.update(todo: mutatedTodo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
    
    func change(todo: Todo, withDate date: Date) async {
        do {
            var mutatedTodo = todo
            mutatedTodo.date = date
            try await repository.update(todo: mutatedTodo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
    
    func change(todo: Todo) async {
        do {
            try await repository.update(todo: todo)
            await loadTodoListAction()
        } catch {
            if let err = error as? RepositoryError {
                commit(mutation: SET_ERROR, payload: err)
            }
        }
    }
}
