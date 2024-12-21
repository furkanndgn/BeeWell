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
    @Published var allQuotes = [QuoteModel]()
    @Published var quoteCount: Int = 0
    
    init(subscription: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscription
    }
    
    func getQuotes() {
        dataManager.getFavoriteQuotes()
    }
    
    func getQuoteCount() -> Int{
        return allQuotes.count
    }
    
    func quote(by index: Int) -> QuoteModel {
        return allQuotes[index]
    }
    
    func removeFromFavorites(_ quote: QuoteModel) {
        dataManager.deleteQuoteFromFavorites(id: quote.id)
        getQuotes()
    }
    
    func addSubscribers() {
        dataManager.$favoriteQuotes
            .sink { [weak self] receivedQuotes in
                self?.allQuotes = receivedQuotes.map(QuoteModel.init)
                self?.quoteCount = receivedQuotes.count
            }
            .store(in: &subscriptions)
    }
}
