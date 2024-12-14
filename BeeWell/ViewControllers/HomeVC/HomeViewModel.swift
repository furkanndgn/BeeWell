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
    @Published var quote: Quote?
    
    init(quoteService: QuoteService = QuoteService(), subscription: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.quoteService = quoteService
        self.subscriptions = subscription
        addSubscribers()
    }
    
    func getQuote() {
        quoteService.getQuote()
    }
    
    private func addSubscribers() {
        quoteService.$quote
            .sink { [weak self] returnedQuote in
                self?.quote = returnedQuote
            }
            .store(in: &subscriptions)
    }
}
