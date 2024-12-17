//
//  ViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import UIKit
import SnapKit
import Combine

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
        let view = DaysView()
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
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        [titleLabel, daysView, divider, quoteCart, buttonStackView].forEach { subView in
            view.addSubview(subView)
        }
        titleLabel.text = viewModel.updateGreeting()
        setupConstraints()
        addSubscriber()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        daysView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(daysView.snp.bottom).offset(8)
        }
        quoteCart.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(8)
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
    }
    
    private func addSubscriber() {
        viewModel.$quote
            .sink { [weak self] recievedQuote in
                self?.quote = recievedQuote
                if let quote = recievedQuote {
                    self?.quoteCart.configureCart(for: quote)
                }
                
            }
            .store(in: &viewModel.subscriptions)
    }
}

#Preview {
    HomeViewController()
}
