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
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.layer.cornerRadius = 24
        label.text = "Lorem ipsum"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(quoteLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        quoteLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(300)
                make.leading.equalToSuperview().offset(12)
                make.trailing.equalToSuperview().offset(-12)
            
            }
    }
}

#Preview {
    QuoteUIView(frame: UIScreen.main.bounds)
}
