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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get a quote.", for: .normal)
        button.addTarget(self, action: #selector(getQuote), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
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
