//
//  QuotesListViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import Foundation
import Combine

class FavoriteQuotesListViewModel: ObservableObject {
    
    let dataManager: FavoriteQuotesRepository
    var subscriptions: Set<AnyCancellable>
    @Published var favoriteQuotes = [QuoteModel]()
    @Published var quoteCount: Int = 0
    
    init(subscription: Set<AnyCancellable> = Set<AnyCancellable>(),
         dataManager: FavoriteQuotesRepository = CoreDataManager.shared) {
        self.dataManager = dataManager
        self.subscriptions = subscription
    }
    
    func getQuotes() {
        favoriteQuotes = dataManager.getAllFavoriteQuotes()
    }
    
    func getQuoteCount() -> Int{
        return favoriteQuotes.count
    }
    
    func quote(by index: Int) -> QuoteModel {
        return favoriteQuotes[index]
    }
    
    func removeFromFavorites(_ quote: QuoteModel) {
        dataManager.removeFromFavorites(quote)
        getQuotes()
    }
}
