//
//  DayCellCollectionViewCell.swift
//  BeeWell
//
//  Created by Furkan Doğan on 15.12.2024.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    static let identifier = "DayCell"
    var isToday: Bool = false
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isToday {
            setupBorder()
        }
    }
    
    private func setupView() {
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.addSubview(dateLabel)
        contentView.addSubview(dayLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with dayTuple: (day: String, date: String), isToday: Bool) {
        dayLabel.text = String(dayTuple.day.prefix(2))
        dateLabel.text = dayTuple.date
        self.isToday = isToday
        if isToday {
            dayLabel.textColor = .label
            dateLabel.textColor = .label
        }
    }
    
    private func setupBorder() {
        let borderColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.secondaryLabel
            default :
                return UIColor.secondaryLabel
            }
        }.cgColor
        contentView.layer.borderColor = borderColor
    }
}

#Preview {
    DayCell(frame: UIScreen.main.bounds)
}
