//
//  WeekUIView.swift
//  BeeWell
//
//  Created by Furkan Doğan on 15.12.2024.
//

import UIKit

class DaysView: UIView {

    private var days: [(day: String, date: String)] = {
        var days: [(day: String, date: String)] = []
        let calendar = Calendar.current
        let today = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EE"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        for offset in stride(from: 6, to: -1, by: -1) {
            if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                let day = dayFormatter.string(from: date)
                let dateString = dateFormatter.string(from: date)
                days.append((day: day, date: dateString))
            }
        }
        return days
    }()
    
    lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 30, height: 45)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
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

extension DaysView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath)
                as? DayCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: days[indexPath.item], isToday: (indexPath.item == days.endIndex - 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 30
        let cellHeight: CGFloat = 45
        let cellSpacing: CGFloat = 16
        let numberOfCells = CGFloat(days.count)
        let totalCellWidth = cellWidth * numberOfCells
        let totalSpacingWidth = cellSpacing * (numberOfCells - 1)
        let horizontalInset = (collectionView.frame.width - (totalCellWidth + totalSpacingWidth)) / 2
        let verticalInset = (collectionView.frame.height - cellHeight) / 2
        return UIEdgeInsets(top: verticalInset, left: max(0, horizontalInset),
                            bottom: verticalInset, right: max(0, horizontalInset))
    }
}

#Preview {
    DaysView(frame: UIScreen.main.bounds)
}
