//
//  QuoteService.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation
import Combine

class QuoteService: QuoteProvider {
    
    private let networkManager: APIService
    private var cancellables: AnyCancellable?
    private let dailyQuoteSubject = CurrentValueSubject<QuoteModel?, Never> (nil)
    
    var dailyQuotePublisher: AnyPublisher<QuoteModel?, Never> {
        dailyQuoteSubject.eraseToAnyPublisher()
    }
    
    init(networkManager: APIService = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getDailyQuote() {
        cancellables = networkManager.performRequest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] quotes in
                self?.dailyQuoteSubject.send(quotes.first)
            })
    }
    
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(String(describing: error.localizedDescription))
        }
    }
}
