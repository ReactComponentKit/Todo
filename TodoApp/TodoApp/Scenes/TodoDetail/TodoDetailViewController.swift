//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by burt on 2022/03/22.
//

import UIKit
import Combine
import SnapKit
import ListKit

final class TodoDetailViewController: UIViewController {
    // It is similar to @EnvironmentObject on SwiftUI.
    private var store = AppStore.shared
    private var cancellables = Set<AnyCancellable>()
    
    private enum Sections {
        case group
    }
    
    private lazy var saveButtonItem = {
        return UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(onClickUpdateButton(_:)))
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ComposeRenderer.emptyLayout)
        return collectionView
    }()
    
    private lazy var renderer = ComposeRenderer(dataSource: PlainDataSource(), delegate: nil, cellClass: nil)
    
    init(todo: Todo) {
        super.init(nibName: nil, bundle: nil)
        self.store.todoDetail.set(todo: todo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.title = "Todo Detail!"
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
        store.$didFinishUpdateTodo
            .receive(on: RunLoop.main)
            .filter { $0 == true }
            .compactMap { $0 }
            .sink { [weak self] value in
                if value {
                    self?.dismiss(animated: true)
                } else {
                    let message = self?.store.todoDetail.state.error.localizedDescription
                    let alert = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func render() {
        renderer.render(animated: false) {
            Section(id: Sections.group) {
                VGroup(width: .fractionalWidth(1.0), height: .estimated(30)) {
                    // Don't use two-way binding
                    TodoTitle(title: store.todoDetail.state.todo.title) { [weak store] newTitle in
                        store?.todoDetail.set(title: newTitle)
                    }
                    // Don't use two-way binding
                    TodoContent(content: store.todoDetail.state.todo.content) { [weak store] newContent in
                        store?.todoDetail.set(content: newContent)
                    }
                    // Don't use two-way binding
                    TodoDate(date: store.todoDetail.state.todo.date) { [weak store] newDate in
                        store?.todoDetail.set(date: newDate)
                    }
                }
            }
            .contentInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        }
    }
}

extension TodoDetailViewController {
    @objc
    func onClickUpdateButton(_ sender: UIBarButtonItem) {
        if (store.todoDetail.state.todo.title.isEmpty) {
            let alert = UIAlertController(title: "Please enter title", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if (store.todoDetail.state.todo.content.isEmpty) {
            let alert = UIAlertController(title: "Please enter content", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        Task {
            await store.updateTodoAction(todo: store.todoDetail.state.todo)
        }
    }
}
