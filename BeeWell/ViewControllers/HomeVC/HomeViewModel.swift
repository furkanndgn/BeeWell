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
    let dataManager = CoreDataManager.shared
    var subscriptions: Set<AnyCancellable>
    @Published var quote: QuoteModel?
    @Published var isFavorited = false
    
    init(quoteService: QuoteService = QuoteService(), subscription: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.quoteService = quoteService
        self.subscriptions = subscription
    }
    
    func addQuoteToStorage(_ quote: QuoteModel) {
        dataManager.addToFavorites(quote)
    }
    
    func checkIfQuoteFavorited(for quote: QuoteModel) {
        isFavorited = dataManager.checkIfFavorited(quote)
        if isFavorited {
            if let quote = dataManager.getQuoteFromFavorites(id: quote.id) {
                let quoteModel = QuoteModel(quote: quote)
                self.quote = quoteModel
            }
        }
    }
    
    func getDailyQuote() {
        if let  quoteOfTheDay = dataManager.fetchQuoteOfTheDay(date: Date().toCSTTime()) {
            quote = QuoteModel(quoteOfTheDay: quoteOfTheDay)
            dataManager.fetchQuoteOfThe7Days()
        } else {
            quoteService.getDailyQuote()
        }
    }
    
    func deleteQuote(_ quote: QuoteModel) {
        dataManager.deleteQuoteFromFavorites(id: quote.id)
        dataManager.getFavoriteQuotes()
        self.quote?.journal = ""
    }
    
    func addSubscribers() {
        quoteService.$dailyQuote
            .sink { [weak self] dailyQuote in
                self?.quote = dailyQuote
                if let quote = dailyQuote {
                    self?.dataManager.addQuoteOfTheDay(quote)
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
