//
//  EmptyStateView.swift
//  BeeWell
//
//  Created by Furkan Doğan on 4.01.2025.
//

import UIKit
import SnapKit

class EmptyStateView: UIView {
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(messageLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView(year: Int?) {
        messageLabel.text =
            """
            It seems \(year ?? 0) is speechless
            add a favorite quote!
            """
    }
}
