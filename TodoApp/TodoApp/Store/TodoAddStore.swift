//
//  TodoAddStore.swift
//  TodoApp
//
//  Created by burt on 2022/03/21.
//

import Foundation
import Redux

struct TodoAddState: State {
    var title: String = ""
    var content: String = ""
    var date: Date = Date()
    var error: RepositoryError = .none
}

class TodoAddStore: Store<TodoAddState> {
    private let repository: Repository
    init(repository: Repository) {
        self.repository = repository
        super.init(state: TodoAddState())
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
}
