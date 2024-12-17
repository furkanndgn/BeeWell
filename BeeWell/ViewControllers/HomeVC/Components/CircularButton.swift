//
//  CircularButton.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import UIKit

class CircularButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
