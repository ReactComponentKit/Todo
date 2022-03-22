//
//  TodoDetailStore.swift
//  TodoApp
//
//  Created by burt on 2022/03/22.
//

import Foundation
import Redux

struct TodoDetailState: State {
    var didFinishUpdateTodo: Bool? = nil
    var todo: Todo = Todo()
    var error: RepositoryError = .none
}

class TodoDetailStore: Store<TodoDetailState> {
    @Published
    var didFinishUpdateTodo: Bool? = nil
    
    private let repository: Repository
    init(repository: Repository) {
        self.repository = repository
        super.init(state: TodoDetailState())
    }
    
    override func computed(new: TodoDetailState, old: TodoDetailState) {
        didFinishUpdateTodo = new.didFinishUpdateTodo
    }
    
    override func worksAfterCommit() -> [(TodoDetailState) -> Void] {
        return [
            { state in
                print(state)
            }
        ]
    }
    
    func set(todo: Todo) {
        commit { mutableState in
            mutableState.didFinishUpdateTodo = nil
            mutableState.error = .none
            mutableState.todo = todo
        }
    }
    
    func set(title: String) {
        commit { mutableState in
            mutableState.todo.title = title
        }
    }
    
    func set(content: String) {
        commit { mutableState in
            mutableState.todo.content = content
        }
    }
    
    func set(date: Date) {
        commit { mutableState in
            mutableState.todo.date = date
        }
    }
    
    func update(todo: Todo) async {
        do {
            commit { mutableState in
                mutableState.didFinishUpdateTodo = false
                mutableState.error = .none
            }
            try await repository.update(todo: todo)
            commit { mutableState in
                mutableState.didFinishUpdateTodo = true
                mutableState.error = .none
            }
        } catch {
            if let err = error as? RepositoryError {
                commit { mutableState in
                    mutableState.didFinishUpdateTodo = true
                    mutableState.error = err
                }
            }
        }
    }
}
