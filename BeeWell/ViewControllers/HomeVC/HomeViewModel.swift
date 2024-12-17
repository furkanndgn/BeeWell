//
//  HomeViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class HomeViewModel {
    
    let quoteService: QuoteService
    var subscriptions: Set<AnyCancellable>
    @Published var quote: QuoteModel?
    
    init(quoteService: QuoteService = QuoteService(), subscription: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.quoteService = quoteService
        self.subscriptions = subscription
        addSubscribers()
    }
    
    func getQuote() {
        quoteService.getRandomQuote()
    }
    
    private func addSubscribers() {
        quoteService.$randomQuote
            .sink { [weak self] returnedQuote in
                self?.quote = returnedQuote
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
