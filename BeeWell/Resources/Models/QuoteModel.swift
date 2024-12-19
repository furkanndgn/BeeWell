//
//  QuoteModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation

struct QuoteModel: Codable {
    
    let id: UUID
    let author, body: String
    let dateString: String
    var journal: String
    
    init(quote: Quote) {
        self.body = quote.body ?? ""
        self.author = quote.author ?? ""
        self.id = quote.id ?? UUID()
        self.journal = quote.journal ?? ""
        self.dateString = quote.dateString ?? Date().toDayString()
    }
    
    init(quoteOfTheDay: QuoteOfTheDay) {
        self.body = quoteOfTheDay.body ?? ""
        self.author = quoteOfTheDay.author ?? ""
        self.id = quoteOfTheDay.id ?? UUID()
        self.dateString = quoteOfTheDay.date?.toDayString() ?? Date().toDayString()
        self.journal = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.body = try container.decode(String.self, forKey: .body)
        self.author = try container.decode(String.self, forKey: .author)
        self.id = UUID()
        self.journal = ""
        self.dateString = Date().toDayString()
    }
    // init for previews and mock data
    init(quote: String, author: String) {
        self.body = quote
        self.author = author
        self.id = UUID()
        self.journal = ""
        self.dateString = Date().toDayString()
    }
    
    enum CodingKeys: String, CodingKey {
        case author = "a"
        case body = "q"
    }
}
