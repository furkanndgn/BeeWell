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
    @Published var quote: Quote?
    
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
    
    lazy var quoteCart: QuoteUIView = {
        let view = QuoteUIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var getButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .thin))
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.configuration = config
        button.addTarget(self, action: #selector(getQuote), for: .touchUpInside)
        return button
    }()
    
    
    init(quote: Quote? = nil, viewModel: HomeViewModel = HomeViewModel()) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getButton.layer.cornerRadius = getButton.bounds.width / 2
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        [titleLabel, daysView, quoteCart, getButton].forEach { subView in
            view.addSubview(subView)
        }
        titleLabel.text = viewModel.updateGreeting()
        setupConstraints()
        addSubscriber()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        daysView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        quoteCart.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(daysView.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaInsets).offset(24)
        }
        getButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(quoteCart.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(40)
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
    
    // MARK: Activation functions
    @objc
    func getQuote(_ sender: UIButton) {
        viewModel.getQuote()
    }
}

#Preview {
    HomeViewController()
}
