//
//  TodoAddViewController.swift
//  TodoApp
//
//  Created by burt on 2022/03/21.
//

import UIKit
import Combine
import SnapKit
import ListKit

final class TodoAddViewController: UIViewController {
    private var store = AppStore.shared
    private var cancellables = Set<AnyCancellable>()
    
    private enum Sections {
        case group
    }
    
    private lazy var saveButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(onClickSaveButton(_:)))
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ComposeRenderer.emptyLayout)
        return collectionView
    }()
    
    private lazy var renderer = ComposeRenderer(dataSource: PlainDataSource(), delegate: nil, cellClass: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupTitle()
        setupDoneButton()
        setupViews()
        setupStore()
        render()
    }
    
    private func setupTitle() {
        self.title = "Add Todo!"
    }
    
    private func setupDoneButton() {
        self.navigationItem.rightBarButtonItem = self.saveButtonItem
    }
    
    private func setupViews() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        renderer.target = collectionView
    }
    
    private func setupStore() {
//        store.todo.$todoList
//            .receive(on: RunLoop.main)
//            .sink { [weak self] todos in
//                self?.todos = todos
//            }
//            .store(in: &cancellables)
    }
    
    private func loadTodoList() {
        Task {
            // await self.store.todo.insertTodoAction(todo:)
        }
    }
    
    private func render() {
        renderer.render(animated: false) {
            Section(id: Sections.group) {
                VGroup(width: .fractionalWidth(1.0), height: .estimated(30)) {
                    // Don't use two-way binding
                    AddTodoTitle(title: store.todoAdd.state.title) { [weak store] newTitle in
                        store?.todoAdd.set(title: newTitle)
                    }
                }
            }
            .contentInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        }
    }
}

extension TodoAddViewController {
    @objc
    func onClickSaveButton(_ sender: UIBarButtonItem) {
        Task {
            
        }
        self.dismiss(animated: true)
    }
}
