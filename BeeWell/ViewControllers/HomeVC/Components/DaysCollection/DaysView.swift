//
//  WeekUIView.swift
//  BeeWell
//
//  Created by Furkan Doğan on 15.12.2024.
//

import UIKit

class DaysView: UIView {
    
    lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 30, height: 45)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    convenience init(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        self.init()
        daysCollectionView.delegate = delegate
        daysCollectionView.dataSource = dataSource
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(daysCollectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        daysCollectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

#Preview {
    DaysView(frame: UIScreen.main.bounds)
}
