//
//  HomeViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
        
    let days: [(day: String, date: String)] = {
        var days: [(day: String, date: String)] = []
        let today = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EE"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        for offset in stride(from: 6, to: -1, by: -1) {
            if let date = Calendar.current.date(byAdding: .day, value: -offset, to: today) {
                let day = dayFormatter.string(from: date)
                let dateString = dateFormatter.string(from: date)
                days.append((day: day, date: dateString))
            }
        }
        return days
    }()
    
    let quoteService: QuoteService
    private let dataManager: HomeScreenQuotesRepository
    let calendar = Calendar.current
    var cancellables: Set<AnyCancellable>
    @Published var quote: QuoteModel?
    @Published var isFavorited = false
    
    init(quoteService: QuoteService = QuoteService(), subscription: Set<AnyCancellable> = Set<AnyCancellable>(),
         dataManager: HomeScreenQuotesRepository = CoreDataManager.shared) {
        self.dataManager = dataManager
        self.quoteService = quoteService
        self.cancellables = subscription
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
    
    func getQuoteOfTheDay(for day: String) {
        let last7Dates = Date().getDatesOf7Days()
        for i in 0...6 {
            if (Int(day) == calendar.component(.day, from: last7Dates[i])) {
                quote = dataManager.getQuoteOfTheDay(for: last7Dates[i])
            }
        }
//        dataManager.getQuoteOfTheDay(for: )
    }
    
    func maintainLimitForCachedQuotes() {
        dataManager.maintainQuoteLimit()
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
            .store(in: &cancellables)
    }
}
