//
//  QuoteUIView.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import UIKit
import SnapKit

class QuoteUIView: UIView {
    
    lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.numberOfLines = 0
        label.text = "Furkan"
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [quoteLabel, authorLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.systemMint.cgColor, UIColor.systemPink.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.addSubview(labelStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
        labelStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 24
    }
}

#Preview {
    QuoteUIView()
}
