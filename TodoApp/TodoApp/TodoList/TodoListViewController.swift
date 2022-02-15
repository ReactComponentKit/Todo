//
//  ViewController.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import UIKit

class TodoListViewController: UIViewController {
    
    private lazy var store: TodoListStore = {
        TodoListStore(repository: LocalDBRepository())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        Task {
            await self.store.loadTodoListAction()
        }
    }
}

