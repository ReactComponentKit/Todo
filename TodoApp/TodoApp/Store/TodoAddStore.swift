//
//  TodoAddStore.swift
//  TodoApp
//
//  Created by burt on 2022/03/21.
//

import Foundation
import Redux

struct TodoAddState: State {
    var didFinishAddTodo: Bool? = nil
    var title: String = ""
    var content: String = ""
    var date: Date = Date()
    var error: RepositoryError = .none
}

class TodoAddStore: Store<TodoAddState> {
    @Published
    var didFinishAddTodo: Bool? = nil
    
    
    private let repository: Repository
    init(repository: Repository) {
        self.repository = repository
        super.init(state: TodoAddState())
    }
    
    override func computed(new: TodoAddState, old: TodoAddState) {
        didFinishAddTodo = new.didFinishAddTodo
    }
    
    override func worksAfterCommit() -> [(TodoAddState) -> Void] {
        return [
            { state in
                print(state)
            }
        ]
    }
    
    func set(title: String) {
        commit { mutableState in
            mutableState.title = title
        }
    }
    
    func set(content: String) {
        commit { mutableState in
            mutableState.content = content
        }
    }
    
    func set(date: Date) {
        commit { mutableState in
            mutableState.date = date
        }
    }
    
    func reset() {
        commit { mutableState in
            mutableState.didFinishAddTodo = false
            mutableState.title = ""
            mutableState.content = ""
            mutableState.date = Date()
            mutableState.error = .none
        }
    }
    
    func insertTodoAction(todo: Todo) async {
        do {
            commit { mutableState in
                mutableState.didFinishAddTodo = false
                mutableState.error = .none
            }
            try await repository.insert(todo: todo)
            commit { mutableState in
                mutableState.didFinishAddTodo = true
                mutableState.error = .none
            }
        } catch {
            if let err = error as? RepositoryError {
                commit { mutableState in
                    mutableState.didFinishAddTodo = true
                    mutableState.error = err
                }
            }
        }
    }
}
