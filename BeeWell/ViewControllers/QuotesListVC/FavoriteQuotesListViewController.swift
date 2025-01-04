//
//  QuotesListViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import UIKit

class FavoriteQuotesListViewController: UIViewController {
    
    let viewModel: FavoriteQuotesListViewModel
    
    lazy var yearSelectionButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.indicator = .none
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        var children: [UIAction] = {
            var array = [UIAction]()
            viewModel.years.forEach { year in
                if year == FavoriteQuotesListViewModel.currentYear {
                    array.append(UIAction(title: "\(year)", state: .on, handler: updateYear))
                } else {
                    array.append(UIAction(title: "\(year)", handler: updateYear))
                }
            }
            return array
        }()
        button.menu = UIMenu(children: children)
        button.changesSelectionAsPrimaryAction = true
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var emptyState = EmptyStateView()
    
    lazy var quotesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuoteCell.self, forCellReuseIdentifier: QuoteCell.identifier)
        tableView.backgroundView = emptyState
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
        viewModel.getQuotesFor()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getQuotesFor(year: viewModel.selectedYear)
        quotesTableView.reloadData()
    }
        
    private func setupView() {
        viewModel.setupYears()
        view.backgroundColor = .systemBackground
        view.addSubview(yearSelectionButton)
        view.addSubview(quotesTableView)
        emptyState.configureView(year: viewModel.selectedYear)
        updateEmptyStateOpacity()
        setupConstraints()
    }
    
    private func setupConstraints() {
        yearSelectionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
        }
        quotesTableView.snp.makeConstraints { make in
            make.top.equalTo(yearSelectionButton.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func updateEmptyStateOpacity() {
        if viewModel.getSectionCount() == 0 {
            emptyState.isHidden = false
        } else {
            emptyState.isHidden = true
        }
    }
    
//    MARK: ActivationFunctions
    private func updateYear(sender: UIAction) {
        viewModel.selectedYear = Int(sender.title)
        viewModel.getQuotesFor(year: viewModel.selectedYear)
        emptyState.configureView(year: viewModel.selectedYear)
        updateEmptyStateOpacity()
        quotesTableView.reloadData()
    }
}

extension FavoriteQuotesListViewController: UITableViewDelegate, UITableViewDataSource,
                                                UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCountFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = quotesTableView.dequeueReusableCell(withIdentifier: QuoteCell.identifier,
                                                             for: indexPath) as? QuoteCell else {
            return UITableViewCell()
        }
        let quote = viewModel.getQuote(by: indexPath.row)
        cell.configureCell(with: quote)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quote = viewModel.getQuote(by: indexPath.row)
        let journalVC = JournalViewController(quoteModel: quote)
        navigationController?.pushViewController(journalVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let quote = viewModel.getQuote(by: indexPath.row)
        viewModel.removeFromFavorites(quote)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (week, year) = {
            let weekYear = viewModel.getWeekYear(section: section)
            return (weekYear.week, weekYear.year)
        }()
        return "Week \(week) of \(year)"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(viewModel.years[row])"
    }
}

#Preview {
    let vm = FavoriteQuotesListViewModel(dataManager: MockFavoriteQuotesRepository())
    FavoriteQuotesListViewController(viewModel: vm)
}
