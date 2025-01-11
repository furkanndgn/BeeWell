//
//  ViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import UIKit
import SnapKit
import Combine
import CoreData

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel
    @Published var quote: QuoteModel?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var daysView: DaysView = {
        let view = DaysView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var divider = HairlineView()
    
    lazy var quoteCart: QuoteUIView = {
        let view = QuoteUIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteButton, writeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var favoriteButton: CircularButton = {
        let button = CircularButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .thin))
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        button.layer.borderWidth = 0.8
        button.configuration = config
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            button.layer.borderColor = UIColor.label.resolvedColor(with: self.traitCollection).cgColor
        }
        button.addTarget(self, action: #selector(addQuoteToFavorites), for: .touchUpInside)
        return button
    }()
    
    lazy var writeButton: CircularButton = {
        let button = CircularButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "pencil",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .thin))
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        button.layer.borderWidth = 0.8
        button.configuration = config
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            button.layer.borderColor = UIColor.label.resolvedColor(with: self.traitCollection).cgColor
        }
        button.addTarget(self, action: #selector(pushJournalVC), for: .touchUpInside)
        return button
    }()
    
    lazy var testButton: CircularButton = {
        let button = CircularButton()
        var config = UIButton.Configuration.filled()
        config.title = "test"
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        button.layer.borderWidth = 0.8
        button.configuration = config
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            button.layer.borderColor = UIColor.label.resolvedColor(with: self.traitCollection).cgColor
        }
        button.addTarget(self, action: #selector(testFunction), for: .touchUpInside)
        return button
    }()
    
    init(quote: QuoteModel? = nil, viewModel: HomeViewModel = HomeViewModel()) {
        self.quote = quote
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubscriber()
        viewModel.addSubscribers()
        viewModel.getDailyQuote()
        viewModel.maintainLimitForCachedQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        [titleLabel, daysView, divider, quoteCart, buttonStackView, testButton].forEach { subView in
            view.addSubview(subView)
        }
        titleLabel.text = updateGreeting()
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.horizontalEdges.equalToSuperview()
        }
        daysView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.06)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(daysView.snp.bottom).offset(12)
        }
        quoteCart.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        favoriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        writeButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(quoteCart.snp.bottom).offset(12)
        }
        testButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonStackView.snp.bottom).offset(24)
        }
    }
    
    private func updateView() {
        if let quote = quote {
            viewModel.checkIfQuoteFavorited(for: quote)
        }
    }
    
    private func updateUI(for day: String) {
        viewModel.getQuoteOfTheDay(for: day)
        quoteCart.authorLabel.text = quote?.author
        quoteCart.quoteLabel.text = quote?.body
    }
    
    private func updateGreeting() -> String{
        let currentHour = Calendar.current.component(.hour, from: Date())
        var greeting: String = ""
        switch currentHour {
        case 5..<12:
            greeting = "good morning."
        case 12..<18:
            greeting = "good afternoon."
        case 18..<22:
            greeting = "good evening."
        default:
            greeting = "good night."
        }
        return greeting
    }
    
    private func addSubscriber() {
        viewModel.$quote
            .sink { [weak self] receivedQuote in
                self?.quote = receivedQuote
                if let quote = receivedQuote {
                    self?.quoteCart.configureCart(for: quote)
                }
            }
            .store(in: &viewModel.cancellables)
        viewModel.$isFavorited
            .sink { [weak self] isFavorited in
                if isFavorited {
                    self?.favoriteButton.configuration?.image =
                    UIImage(systemName: "star.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .thin))
                   
                }
                else {
                    self?.favoriteButton.configuration?.image =
                    UIImage(systemName: "star",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .thin))
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    @objc func pushJournalVC() {
        if let quote = quote {
            navigationController?.pushViewController(JournalViewController(quoteModel: quote), animated: true)
        }
    }
    
    @objc func addQuoteToFavorites() {
        if let quote = quote {
            if !viewModel.isFavorited {
                viewModel.addQuoteToStorage(quote)
            } else {
                viewModel.deleteQuote(quote)
            }
            updateView()
        }
    }
    
    @objc func testFunction() {
//        CoreDataManager.shared.fetchQuoteOfThe7Days()
        viewModel.getQuoteOfTheDay(for: "")
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath)
                as? DayCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.days[indexPath.item], isToday: (indexPath.item == viewModel.days.endIndex - 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 30
        let cellHeight: CGFloat = 45
        let cellSpacing: CGFloat = 16
        let numberOfCells = CGFloat(7)
        let totalCellWidth = cellWidth * numberOfCells
        let totalSpacingWidth = cellSpacing * (numberOfCells - 1)
        let horizontalInset = (collectionView.frame.width - (totalCellWidth + totalSpacingWidth)) / 2
        let verticalInset = (collectionView.frame.height - cellHeight) / 2
        return UIEdgeInsets(top: verticalInset, left: max(0, horizontalInset),
                            bottom: verticalInset, right: max(0, horizontalInset))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        daysView.daysCollectionView.deselectItem(at: indexPath, animated: true)
        updateUI(for: viewModel.days[indexPath.item].date)
    }
}

#Preview {
    HomeViewController()
}
