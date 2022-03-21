//
//  AddTodoTitle.swift
//  TodoApp
//
//  Created by burt on 2022/03/21.
//

import UIKit
import SnapKit
import ListKit

struct AddTodoTitle: Component {
    typealias Content = AddTodoTitleView
    
    let title: String
    var onTitleChanged: ((String) -> Void)?
    
    var id: AnyHashable {
        UUID()
    }
    
    init(title: String, onTitleChanged: @escaping (String) -> Void) {
        self.title = title
        self.onTitleChanged = onTitleChanged
    }
    
    func contentView() -> AddTodoTitleView {
        return AddTodoTitleView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
    }
    
    func edgeSpacing() -> NSCollectionLayoutEdgeSpacing? {
        return .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(8.0))
    }
    
    func render(in content: AddTodoTitleView) {
        content.titleTextField.text = title
        content.onTitleChanged = onTitleChanged
    }
}


final class AddTodoTitleView: UIView, UITextFieldDelegate {
    
    var onTitleChanged: ((String) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "TITLE"
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        return textField
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldRange = NSRange(location: 0, length: textField.text?.count ?? 0)
        if NSEqualRanges(range, textFieldRange) && string.count == 0 {
            onTitleChanged?("")
        } else {
            onTitleChanged?(textField.text ?? "")
        }
        return true
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.titleLabel, self.titleTextField])
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
        
    override func layoutSubviews() {
        super.layoutSubviews()
        if (titleTextField.canBecomeFirstResponder) {
            titleTextField.becomeFirstResponder()
        }
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
        titleTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
    
