//
//  HairlineView.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import UIKit

class HairlineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
     
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
