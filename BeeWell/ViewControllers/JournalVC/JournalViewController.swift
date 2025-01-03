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
    
    let dataManager: FavoriteQuotesRepository
    var quoteModel: QuoteModel
    let placeHolder: String = "Start writing your thoughts..."
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
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
        label.text = quoteModel.body
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
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        if quoteModel.journal.isEmpty {
            textView.text = placeHolder
            textView.textColor = .secondaryLabel
        } else {
            textView.text = quoteModel.journal
            textView.textColor = .label
        }
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.inputAccessoryView = toolbar
        return textView
    }()
    
    lazy var toolbar: UIToolbar = {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        bar.sizeToFit()
        bar.setItems([flexibleSpace, doneButton], animated: true)
        return bar
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        return button
    }()
    
    lazy var flexibleSpace: UIBarButtonItem = {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        return space
    }()
    
    init(quoteModel: QuoteModel, dataManager: FavoriteQuotesRepository = CoreDataManager.shared) {
        self.quoteModel = quoteModel
        self.dataManager = dataManager
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
    
    private func saveNewJournal() {
        dataManager.updateJournal(of: quoteModel)
    }
    
    //    MARK: Activation Functions
    @objc private func toggleEditMode() {
        journalTextView.isEditable.toggle()
        if journalTextView.isEditable {
            editButton.title = "Done"
        } else {
            if journalTextView.text != placeHolder {
                quoteModel.journal = journalTextView.text
            }
            saveNewJournal()
            editButton.title = "Edit"
        }
    }
    
    @objc private func doneButtonTapped() {
        journalTextView.endEditing(true)
    }
}

extension JournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if quoteModel.journal.isEmpty {
            textView.text = ""
            textView.textColor = .label // Switch to text color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            quoteModel.journal = ""
            textView.text = placeHolder
            textView.textColor = .secondaryLabel
        }
    }
}
