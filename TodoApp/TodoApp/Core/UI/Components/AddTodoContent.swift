//
//  AddTodoContent.swift
//  TodoApp
//
//  Created by burt on 2022/03/21.
//

import UIKit
import SnapKit
import ListKit

struct AddTodoContent: Component {
    typealias Content = AddTodoContentView
    
    let contentValue: String
    var onContentChanged: ((String) -> Void)?
    
    var id: AnyHashable {
        UUID()
    }
    
    init(content: String, onContentChanged: @escaping (String) -> Void) {
        self.contentValue = content
        self.onContentChanged = onContentChanged
    }
    
    func contentView() -> AddTodoContentView {
        return AddTodoContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
    }
    
    func edgeSpacing() -> NSCollectionLayoutEdgeSpacing? {
        return .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(8.0))
    }
    
    func render(in content: AddTodoContentView) {
        content.contentTextView.text = contentValue
        content.onContentChanged = onContentChanged
    }
}


final class AddTodoContentView: UIView {
    
    var onContentChanged: ((String) -> Void)?
    
    lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "CONTENT"
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.delegate = self
        return textView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.contentLabel, self.contentTextView])
        stack.axis = .vertical
        stack.alignment = .top
        stack.spacing = 6
        return stack
    }()
    
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
        contentTextView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}

extension AddTodoContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onContentChanged?(textView.text ?? "")
    }
}
    
