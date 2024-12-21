//
//  QuoteCellTableViewCell.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import UIKit
import Combine

class QuoteCell: UITableViewCell {

    static let identifier = "QuoteCell"
    
    lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(quoteLabel)
        contentView.addSubview(dateLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        quoteLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(quoteLabel)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configureCell(with quoteModel: QuoteModel) {
        quoteLabel.text = quoteModel.body
        dateLabel.text = quoteModel.date.toUTC3Time().formatted(date: .abbreviated, time: .omitted)
    }
}

#Preview {
    QuoteCell()
}
