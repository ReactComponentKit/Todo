//
//  Todo.swift
//  TodoApp
//
//  Created by burt on 2022/02/15.
//

import UIKit
import ListKit

struct TodoItem: Component {
    
    
    typealias Content = TodoItemContentView
    
    let todo: Todo
    
    var id: AnyHashable {
        todo.id
    }
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    func contentView() -> TodoItemContentView {
        return TodoItemContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
    }
    
    func render(in content: TodoItemContentView) {
        
    }
}


final class TodoItemContentView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        self.backgroundColor = .red
    }
}
