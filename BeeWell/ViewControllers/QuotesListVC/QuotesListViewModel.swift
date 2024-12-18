//
//  QuotesListViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import Foundation
import Combine

class QuotesListViewModel: ObservableObject {
    
    let dataManager = CoreDataManager.shared
    var subscriptions: Set<AnyCancellable>
    @Published var allQuotes = [QuoteListModel]()
    @Published var quoteCount: Int = 0
    
    init(subscription: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscription
    }
    
    func getQuotes() {
        dataManager.getAllQuotes()
    }
    
    func getQuoteCount() -> Int{
        return allQuotes.count
    }
    
    func quote(by index: Int) -> QuoteListModel {
        return allQuotes[index]
    }
    
    func addSubscribers() {
        dataManager.$fetchedQuotes
            .sink { [weak self] receivedQuotes in
                self?.allQuotes = receivedQuotes.map(QuoteListModel.init)
                self?.quoteCount = receivedQuotes.count
            }
            .store(in: &subscriptions)
    }
}
