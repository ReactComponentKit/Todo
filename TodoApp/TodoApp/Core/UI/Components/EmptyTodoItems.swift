//
//  EmptyTodoItems.swift
//  TodoApp
//
//  Created by burt on 2022/02/15.
//

import UIKit
import SnapKit
import ListKit

struct EmptyTodoItems: Component {
    
    typealias Content = EmptyTodoItemsContentView
    
    var id: AnyHashable = UUID()
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func contentView() -> EmptyTodoItemsContentView {
        return EmptyTodoItemsContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
    }
    
    func render(in content: EmptyTodoItemsContentView) {
        content.label.text = title
    }
}


final class EmptyTodoItemsContentView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

