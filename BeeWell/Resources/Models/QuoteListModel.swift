//
//  QuoteListModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import Foundation

struct QuoteListModel {
    private var quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    var id: UUID {
        quote.id ?? UUID()
    }
    
    var dateString: String {
        quote.dateString ?? Date().toDayString()
    }
    
    var content: String {
        quote.content ?? ""
    }
    
    var author: String {
        quote.author ?? ""
    }
    
    var journal: String {
        quote.journal ?? ""
    }

}
