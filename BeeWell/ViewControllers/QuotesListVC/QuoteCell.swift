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
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
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
        contentView.addSubview(quoteLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        quoteLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    func configureCell(with quoteModel: QuoteModel) {
        quoteLabel.text = quoteModel.body
    }
}

#Preview {
    QuoteCell()
}
