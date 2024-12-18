//
//  JournalViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import UIKit
import SnapKit
import Combine

class JournalViewController: UIViewController {
    
    var quoteModel: QuoteModel
    let viewModel: HomeViewModel
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editJournal))
        button.isEnabled = true
        return button
    }()
    
    lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Is there any immediate lesson from this quote—something I could apply in my life right now?"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = quoteModel.quote
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = quoteModel.author
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var journalTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.text = quoteModel.journal
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        return textView
    }()
    
    init(quoteModel: QuoteModel, viewModel: HomeViewModel) {
        self.quoteModel = quoteModel
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubscribers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkIfQuoteFavorited(for: quoteModel)
        journalTextView.text = quoteModel.journal
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = editButton
        [promptLabel, quoteLabel, authorLabel, journalTextView].forEach { subView in
            view.addSubview(subView)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        promptLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        quoteLabel.snp.makeConstraints { make in
            make.top.equalTo(promptLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(quoteLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(quoteLabel.snp.horizontalEdges)
        }
        journalTextView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func addSubscribers() {
        viewModel.$quote
            .sink { [weak self] receivedQuote in
                if let quote = receivedQuote {
                    self?.quoteModel = quote
                }
            }
            .store(in: &viewModel.subscriptions)
    }
    
    //    MARK: Activation Functions
    @objc private func editJournal() {
        navigationController?.pushViewController(JournalEditViewController(quoteModel: quoteModel, isQuoteSaved: true), animated: false)
    }
}
//
//#Preview {
//    let quote = QuoteModel(quote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", author: "Furkan", journal: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?")
//    JournalViewController(quoteModel: quote)
//}
