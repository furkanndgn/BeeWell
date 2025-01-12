//
//  QuoteProvider.swift
//  BeeWell
//
//  Created by Furkan Doğan on 12.01.2025.
//

import Combine

protocol QuoteProvider {
    var dailyQuotePublisher: AnyPublisher<QuoteModel?, Never> { get }
    func getDailyQuote()
}
