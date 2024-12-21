//
//  MainTabBarController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 21.12.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    let homeVC: HomeViewController
    let favoritesVC: FavoriteQuotesListViewController
    let homeNav: UINavigationController
    let favoritesNav: UINavigationController
    
    init(homeVC: HomeViewController = HomeViewController(), favoritesVC: FavoriteQuotesListViewController =
         FavoriteQuotesListViewController(viewModel: FavoriteQuotesListViewModel())) {
        self.homeVC = homeVC
        self.favoritesVC = favoritesVC
        homeNav = UINavigationController(rootViewController: self.homeVC)
        favoritesNav = UINavigationController(rootViewController: self.favoritesVC)
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
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "list.star"), tag: 1)
        self.viewControllers = [homeNav, favoritesNav]
    }
}
