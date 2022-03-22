//
//  Todo.swift
//  TodoApp
//
//  Created by burt on 2022/02/15.
//

import UIKit
import SnapKit
import ListKit

struct TodoItem: Component {
    typealias Content = TodoItemContentView
    
    let todo: Todo
    
    var id: AnyHashable {
        todo
    }
    
    var onClickTodo: ((Todo) -> Void)?
    
    init(todo: Todo, onClickTodo: @escaping (Todo) -> Void) {
        self.todo = todo
        self.onClickTodo = onClickTodo
    }
    
    func contentView() -> TodoItemContentView {
        return TodoItemContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
    }
    
    func edgeSpacing() -> NSCollectionLayoutEdgeSpacing? {
        return .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(8.0))
    }
    
    func render(in content: TodoItemContentView) {
        content.titleLabel.text = todo.title
        content.contentLabel.text = todo.content
        content.dateLabel.text = DateUtils.dateToString(todo.date)
        content.onClickContentView = {
            onClickTodo?(todo)
        }
    }
}


final class TodoItemContentView: UIView {
    
    private lazy var textColor: UIColor = UIColor.black
    private lazy var dateColor: UIColor = UIColor.lightGray
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = self.textColor
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = -1
        label.textColor = self.textColor
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = self.dateColor
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.titleLabel, self.contentLabel, self.dateLabel])
        stack.axis = .vertical
        stack.alignment = .top
        stack.spacing = 16
        return stack
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    }()
    
    var onClickContentView: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupAppearance()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupAppearance() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.2
    }
    
    func setupViews() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        self.addGestureRecognizer(self.tapGesture)
    }
    
    @objc
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
        onClickContentView?()
    }
}
