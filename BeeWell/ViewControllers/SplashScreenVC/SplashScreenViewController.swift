//
//  SplashScreenViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 15.12.2024.
//

import UIKit

class SplashScreenViewController: UIViewController {

    let quoteService: QuoteService
    let homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel = HomeViewModel(), quoteService: QuoteService = QuoteService()) {
        self.homeViewModel = homeViewModel
        self.quoteService = quoteService
        super.init(nibName: nil, bundle: nil)
        addSubscribers()
        quoteService.getDailyQuote()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.transitionToMainApp()
        })
    }
    
    private func addSubscribers() {
        quoteService.$randomQuote
            .sink { [weak self] recievedQuote in
                self?.homeViewModel.quote = recievedQuote
            }
            .store(in: &homeViewModel.subscriptions)
    }
    
    private func transitionToMainApp() {
        guard let scene = view.window?.windowScene else {
            print("No active UIWindowScene found.")
            return
        }
        if let window = scene.windows.first {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
            let homeScreen = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))
            window.rootViewController = homeScreen
            window.makeKeyAndVisible()
        }
    }
}
