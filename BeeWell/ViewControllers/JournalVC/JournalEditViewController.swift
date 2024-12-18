//
//  QuoteJournalViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import UIKit
import SnapKit

class JournalEditViewController: UIViewController {

    var quoteModel: QuoteModel
    var isQuoteSaved: Bool
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewJournal))
        button.isEnabled = false
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
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        if quoteModel.journal.isEmpty {
            textView.text = "Start writing your thoughts..."
            textView.textColor = .secondaryLabel
        } else {
            textView.text = quoteModel.journal
            textView.textColor = .label
        }
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.inputAccessoryView = toolbar
        return textView
    }()
    
    lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.translatesAutoresizingMaskIntoConstraints = false
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

    
    init(quoteModel: QuoteModel, isQuoteSaved: Bool = false) {
        self.quoteModel = quoteModel
        self.isQuoteSaved = isQuoteSaved
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupView() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = saveButton
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
    
//    MARK: Activation Functions
    @objc private func saveNewJournal() {
        quoteModel.journal = journalTextView.text
        if isQuoteSaved {
            CoreDataManager.shared.updateJournal(quoteModel: quoteModel)
        } else {
            CoreDataManager.shared.addNewQuote(quoteModel)
        }
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func doneButtonTapped() {
        journalTextView.resignFirstResponder()
    }
}

extension JournalEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label // Switch to text color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Start writing your thoughts..."
            textView.textColor = .secondaryLabel
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


#Preview {
    let quote = QuoteModel(quote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", author: "Furkan")
    JournalEditViewController(quoteModel: quote)
}
