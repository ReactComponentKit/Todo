//
//  ViewController.swift
//  TodoApp
//
//  Created by burt on 2021/11/09.
//

import UIKit
import Combine
import SnapKit
import ListKit

final class TodoListViewController: UIViewController {
    
    private var store = AppStore.shared
    private var cancellables = Set<AnyCancellable>()
    private var todos: [Todo] = [] {
        didSet {
            render()
        }
    }
    
    private enum Sections {
        case list
    }
    
    private lazy var addTodoButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onClickAddTodoButton(_:)))
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ComposeRenderer.emptyLayout)
        return collectionView
    }()
    
    private lazy var renderer = ComposeRenderer(dataSource: DiffableDataSource(), delegate: nil, cellClass: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupTitle()
        setupAddButton()
        setupViews()
        setupStore()
        loadTodoList()
    }
    
    private func setupTitle() {
        self.title = "ToDo!"
    }
    
    private func setupAddButton() {
        self.navigationItem.rightBarButtonItem = self.addTodoButtonItem
    }
    
    private func setupViews() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        renderer.target = collectionView
    }
    
    private func setupStore() {
        store.todoList.$todoList
            .receive(on: RunLoop.main)
            .sink { [weak self] todos in
                self?.todos = todos
            }
            .store(in: &cancellables)
    }
    
    private func loadTodoList() {
        Task {
            await self.store.todoList.loadTodoListAction()
        }
    }
    
    private func render() {        
        renderer.render(animated: true) {
            Section(id: Sections.list) {
                if todos.isEmpty {
                    VGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0)) {
                        EmptyTodoItems(title: "Add Todo!")
                    }
                } else {
                    VGroup(of: todos, width: .fractionalWidth(1.0), height: .estimated(30)) { todo in
                        TodoItem(todo: todo)
                    }
                }
            }
            .contentInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        }
    }
}

extension TodoListViewController {
    @objc
    func onClickAddTodoButton(_ sender: UIBarButtonItem) {
        let nvc = UINavigationController(rootViewController: TodoAddViewController())
        self.present(nvc, animated: true)
    }
}
