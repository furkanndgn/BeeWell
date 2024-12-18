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
    @Published var favoriteQuotes = [Quote]()
    @Published var isFavorited = false
    
    init(quoteService: QuoteService = QuoteService(), subscription: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.quoteService = quoteService
        self.subscriptions = subscription
    }
    
    func addQuoteToStorage(_ quote: QuoteModel) {
        dataManager.addNewQuote(quote)
        checkIfQuoteFavorited(for: quote)
        fetchQuotesFromStorage()
    }
    
    func fetchQuotesFromStorage() {
        dataManager.getAllQuotes()
    }
    
    func checkIfQuoteFavorited(for quote: QuoteModel) {
        isFavorited = dataManager.checkIfAlreadyStored(quoteModel: quote)
        if isFavorited {
            let a = dataManager.getQuote(dateString: quote.dateString)
            let coreQuote = QuoteModel(quote: a!.content!, author: a!.author!, journal: a!.journal!)
            self.quote = coreQuote
            print(coreQuote.journal)
        }
    }
    
    func deleteQuote(_ quote: QuoteModel) {
        dataManager.deleteQuote(dateString: quote.dateString)
        checkIfQuoteFavorited(for: quote)
    }
    
     func addSubscribers() {
        quoteService.getDailyQuote()

        dataManager.$fetchedQuotes
            .sink { [weak self] returnedQuotes in
                self?.favoriteQuotes = returnedQuotes
                print(self?.favoriteQuotes ?? "burda core data")
                print(returnedQuotes.first?.journal ?? "", "journal burda")
            }
            .store(in: &subscriptions)
        quoteService.$dailyQuote
            .sink { [weak self] receivedQuote in
                self?.quote = receivedQuote
                if let quote = receivedQuote {
                    self?.checkIfQuoteFavorited(for: quote)
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
