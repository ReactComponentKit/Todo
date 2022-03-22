//
//  AddTodoDate.swift
//  TodoApp
//
//  Created by burt on 2022/03/21.
//

import UIKit
import SnapKit
import ListKit

struct TodoDate: Component {
    typealias Content = TodoDateView
    
    let date: Date
    var onDateChanged: ((Date) -> Void)?
    
    var id: AnyHashable {
        UUID()
    }
    
    init(date: Date, onDateChanged: @escaping (Date) -> Void) {
        self.date = date
        self.onDateChanged = onDateChanged
    }
    
    func contentView() -> TodoDateView {
        return TodoDateView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
    }
    
    func edgeSpacing() -> NSCollectionLayoutEdgeSpacing? {
        return .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(8.0))
    }
    
    func render(in content: TodoDateView) {
        content.datePicker.date = date
        content.onDateChanged = onDateChanged
    }
}


final class TodoDateView: UIView {
    
    var onDateChanged: ((Date) -> Void)?
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "DATE"
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.preferredDatePickerStyle = .automatic
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        picker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        return picker
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.dateLabel, self.datePicker])
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
        datePicker.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    @objc
    func handleDatePicker(_ picker: UIDatePicker) {
        onDateChanged?(picker.date)
    }
}


