//
//  QuoteOfTheDayRepository.swift
//  BeeWell
//
//  Created by Furkan Doğan on 22.12.2024.
//

import Foundation

protocol QuoteOfTheDayRepository {
    
    func saveQuoteOfTheDay(_ quoteModel: QuoteModel)
    
    func getQuoteOfTheDay(for date: Date) -> QuoteModel?
    
    func maintainQuoteLimit()
}
