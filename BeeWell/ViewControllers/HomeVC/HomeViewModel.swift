//
//  HomeViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    let quoteService: QuoteService
    let dataManager: HomeScreenQuotesRepository
    var subscriptions: Set<AnyCancellable>
    @Published var quote: QuoteModel?
    @Published var isFavorited = false
    
    init(quoteService: QuoteService = QuoteService(), subscription: Set<AnyCancellable> = Set<AnyCancellable>(),
         dataManager: HomeScreenQuotesRepository = CoreDataManager.shared) {
        self.dataManager = dataManager
        self.quoteService = quoteService
        self.subscriptions = subscription
    }
    
    func addQuoteToStorage(_ quote: QuoteModel) {
        dataManager.addToFavorites(quote)
    }
    
    func checkIfQuoteFavorited(for quote: QuoteModel) {
        isFavorited = dataManager.checkIfQuoteFavorited(for: quote)
        if isFavorited {
            if let quote = dataManager.getQuoteFromFavorites(with: quote.id) {
                self.quote = quote
            }
        }
    }
    
    func getDailyQuote() {
        if let  quoteOfTheDay = dataManager.getQuoteOfTheDay(for: Date().toCSTTime()) {
            quote = quoteOfTheDay
        } else {
            quoteService.getDailyQuote()
        }
    }
    
    func deleteQuote(_ quote: QuoteModel) {
        dataManager.removeFromFavorites(quote)
        self.quote?.journal = ""
    }
    
    func addSubscribers() {
        quoteService.$dailyQuote
            .sink { [weak self] dailyQuote in
                self?.quote = dailyQuote
                if let quote = dailyQuote {
                    self?.dataManager.saveQuoteOfTheDay(quote)
                }
            }
            .store(in: &subscriptions)
    }
    
    func updateGreeting() -> String{
        let currentHour = Calendar.current.component(.hour, from: Date())
        var greeting: String = ""
        switch currentHour {
        case 5..<12:
            greeting = "good morning."
        case 12..<18:
            greeting = "good afternoon."
        case 18..<22:
            greeting = "good evening."
        default:
            greeting = "good night."
        }
        return greeting
    }
}
