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
    private var cancellables: AnyCancellable?
    @Published var dailyQuote: QuoteModel?
    
    func getDailyQuote() {
        cancellables = networkManager.performRequest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] returnedQuotes in
                self?.dailyQuote = returnedQuotes.first
                self?.cancellables?.cancel()
            })
    }
}
