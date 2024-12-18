//
//  QuoteModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 13.12.2024.
//

import Foundation

struct QuoteModel: Codable {
    let quote, author: String
    let id = UUID()
    var journal = ""
    let dateString = Date().toDayString()
    
    enum CodingKeys: String, CodingKey {
        case quote = "q"
        case author = "a"
    }
}
