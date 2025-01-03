//
//  QuotesRepository.swift
//  BeeWell
//
//  Created by Furkan Doğan on 22.12.2024.
//

import Foundation
import Combine

protocol FavoriteQuotesRepository {
    
    var favoriteQuotes: [QuoteModel] { get set }
    
    func getAllFavoriteQuotes() -> [QuoteModel]
    
    func getFavoriteQuotesOfYear(for year: Int) -> [QuoteModel]
    
    func getQuoteFromFavorites(with id: UUID) -> QuoteModel?
    
    func addToFavorites(_ quoteModel: QuoteModel)
    
    func checkIfQuoteFavorited(for quoteModel: QuoteModel) -> Bool
    
    func removeFromFavorites(_ quoteModel: QuoteModel)
    
    func updateJournal(of quoteModel: QuoteModel)
    
    func deleteAllFavorites()
}
