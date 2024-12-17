//
//  JournalModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import Foundation

struct JournalModel {
    let id = UUID()
    let quoteID: UUID
    let content, date: String
}
