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

    let viewModel = HomeViewModel()
    @Published var quote: Quote?
    
    lazy var getButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "Get a Quote"
        config.baseBackgroundColor = .systemYellow
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.cornerStyle = .medium
        button.configuration = config
        button.addTarget(self, action: #selector(getQuote), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(getButton)
        setupConstraints()
        addSubscriber()
    }
    
    private func setupConstraints() {
        getButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func addSubscriber() {
        viewModel.$quote
            .sink { [weak self] recievedQuote in
                self?.quote = recievedQuote
                print(self?.quote?.quote ?? "")
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
