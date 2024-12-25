//
//  QuotesListViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import UIKit

class FavoriteQuotesListViewController: UIViewController {
    
    let viewModel: FavoriteQuotesListViewModel
    
    lazy var quotesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuoteCell.self, forCellReuseIdentifier: QuoteCell.identifier)
        return tableView
    }()
    
    init(viewModel: FavoriteQuotesListViewModel = FavoriteQuotesListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getQuotes()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getQuotes()
        quotesTableView.reloadData()
        print(quotesTableView.numberOfSections)
    }
        
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(quotesTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        quotesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension FavoriteQuotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getQuoteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = quotesTableView.dequeueReusableCell(withIdentifier: QuoteCell.identifier,
                                                             for: indexPath) as? QuoteCell else {
            return UITableViewCell()
        }
        let quote = viewModel.quote(by: indexPath.row)
        cell.configureCell(with: quote)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quote = viewModel.quote(by: indexPath.row)
        let journalVC = JournalViewController(quoteModel: quote)
        navigationController?.pushViewController(journalVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let quote = viewModel.quote(by: indexPath.row)
        viewModel.removeFromFavorites(quote)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hehehe"
    }
}

#Preview {
    let vm = FavoriteQuotesListViewModel(dataManager: MockFavoriteQuotesRepository())
    FavoriteQuotesListViewController(viewModel: vm)
}
