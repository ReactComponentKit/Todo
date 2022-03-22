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
    // It is similar to @EnvironmentObject on SwiftUI.
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
        store.$didFinishAddTodo
            .receive(on: RunLoop.main)
            .filter { $0 == true }
            .compactMap { $0 }
            .sink { [weak self] value in
                if value {
                    // it is not necessary if we've injected a new store but we use a singleton store.
                    self?.store.todoAdd.reset()
                    self?.dismiss(animated: true)
                } else {
                    let message = self?.store.todoAdd.state.error.localizedDescription
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
                    TodoTitle(title: store.todoAdd.state.title) { [weak store] newTitle in
                        store?.todoAdd.set(title: newTitle)
                    }
                    // Don't use two-way binding
                    TodoContent(content: store.todoAdd.state.content) { [weak store] newContent in
                        store?.todoAdd.set(content: newContent)
                    }
                    // Don't use two-way binding
                    TodoDate(date: store.todoAdd.state.date) { [weak store] newDate in
                        store?.todoAdd.set(date: newDate)
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
        
        if (store.todoAdd.state.title.isEmpty) {
            let alert = UIAlertController(title: "Please enter title", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if (store.todoAdd.state.content.isEmpty) {
            let alert = UIAlertController(title: "Please enter content", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        Task {
            await store.addNewTodoAction(title: store.todoAdd.state.title, content: store.todoAdd.state.content, date: store.todoAdd.state.date)
        }
    }
}
