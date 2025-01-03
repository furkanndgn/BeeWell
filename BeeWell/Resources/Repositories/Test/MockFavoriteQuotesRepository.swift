//
//  MockFavoriteQuotesRepository.swift
//  BeeWell
//
//  Created by Furkan Doğan on 25.12.2024.
//

import Foundation

class MockFavoriteQuotesRepository: FavoriteQuotesRepository {
    
    var favoriteQuotes: [QuoteModel] = [
        QuoteModel(body:
                    """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt 
                    ut labore et dolore magna aliqua. Ut enim ad      
                    minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
                    Duis aute irure dolor in reprehenderit in voluptate velit 
                    esse cillum dolore eu fugiat nulla pariatur.
                    """,
                   author: "furkido", date: Date().advanced(by: -86400)),
        QuoteModel(body: "hallederiz anam", author: "kokito", date: Date().advanced(by: -86400 * 2)),
        QuoteModel(body: "zink. zink. zink", author: "furki", date: Date().advanced(by: -86400 * 3)),
        QuoteModel(body: "ozr dlrm", author: "o", date: Date().advanced(by: -86400 * 4)),
        QuoteModel(body: "hehehe.", author: "onlar", date: Date().advanced(by: -86400 * 5))
    ]
    
    func getAllFavoriteQuotes() -> [QuoteModel] {
        return favoriteQuotes
    }
    
    func getFavoriteQuotesOfYear(for year: Int) -> [QuoteModel] {
        return []
    }
    
    func getQuoteFromFavorites(with id: UUID) -> QuoteModel? {
        return favoriteQuotes.first { $0.id == id}
    }
    
    func addToFavorites(_ quoteModel: QuoteModel) {
        favoriteQuotes.append(quoteModel)
    }
    
    func checkIfQuoteFavorited(for quoteModel: QuoteModel) -> Bool {
        return favoriteQuotes.contains { $0.id == quoteModel.id }
        }
    
    func removeFromFavorites(_ quoteModel: QuoteModel) {
        if checkIfQuoteFavorited(for: quoteModel) {
            favoriteQuotes.removeAll { $0.id == quoteModel.id }
        } else {
            print("Couldn't find given quote in favorited quotes.")
        }
    }
    
    func updateJournal(of quoteModel: QuoteModel) {
        if var quote = getQuoteFromFavorites(with: quoteModel.id) {
            quote.journal = quoteModel.journal
        }
    }
    
    func deleteAllFavorites() {
        favoriteQuotes.removeAll()
    }
}
