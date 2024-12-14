//
//  QuoteService.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class QuoteService: ObservableObject {
    
    private let networkManager = NetworkManager.shared
    private var quoteSubscription: AnyCancellable?
    @Published var quote: Quote?
    
    func getQuote() {
        quoteSubscription = networkManager.performRequest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] returnedQuotes in
                self?.quote = returnedQuotes.first
                self?.quoteSubscription?.cancel()
            })
    }
}
