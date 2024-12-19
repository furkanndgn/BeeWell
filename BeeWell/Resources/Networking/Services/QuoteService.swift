//
//  QuoteService.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class QuoteService {
    
    private let networkManager = NetworkManager.shared
    private var quoteSubscription: AnyCancellable?
    @Published var dailyQuote: QuoteModel?
    
    func getDailyQuote() {
        quoteSubscription = networkManager.performRequest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] returnedQuotes in
                self?.dailyQuote = returnedQuotes.first
                self?.quoteSubscription?.cancel()
            })
    }
}
