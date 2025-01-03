//
//  QuotesSection.swift
//  BeeWell
//
//  Created by Furkan Doğan on 2.01.2025.
//

import Foundation

struct QuotesSection {
    let weekYear: WeekYear
    let quotes: [QuoteModel]
}

struct WeekYear: Hashable {
    let week: Int
    let year: Int
}

