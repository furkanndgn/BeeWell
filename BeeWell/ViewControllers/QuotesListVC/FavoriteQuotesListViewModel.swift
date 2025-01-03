//
//  QuotesListViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import Foundation

class FavoriteQuotesListViewModel {
    
    let dataManager: FavoriteQuotesRepository
    private var favoriteQuotes = [QuoteModel]()
    var groupedQuotes = [QuotesSection]()
    var quoteCount: Int = 0
    
    init(dataManager: FavoriteQuotesRepository = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    
    func getQuotes() {
        favoriteQuotes = dataManager.getFavoriteQuotesOfYear(for: 2024)
        groupedQuotes = groupQuotesByWeek(favoriteQuotes)
    }
    
    func getQuoteCount() -> Int {
        return favoriteQuotes.count
    }
    
    func getSectionCount() -> Int {
        return groupedQuotes.count
    }
    
    func getRowCountFor(section: Int) -> Int {
        return groupedQuotes[section].quotes.count
    }
    
    func getWeekYear(section: Int) -> WeekYear {
        return groupedQuotes[section].weekYear
    }
    
    func getQuote(by index: Int) -> QuoteModel {
        return favoriteQuotes[index]
    }
    
    func removeFromFavorites(_ quote: QuoteModel) {
        dataManager.removeFromFavorites(quote)
        getQuotes()
    }
    
    private func groupQuotesByWeek(_ quotes: [QuoteModel]) -> [QuotesSection] {
        let calendar = Calendar.current
        let groupedQuotes = Dictionary(grouping: quotes) { quote in
            let year = calendar.component(.year, from: quote.date)
            let week = calendar.component(.weekOfYear, from: quote.date)
            return WeekYear(week: week, year: year)
        }
        return groupedQuotes.map { (weekYear, quotes) in
            QuotesSection(weekYear: weekYear, quotes: quotes)
        }
        .sorted {
            $0.weekYear.year == $1.weekYear.year
            ? $0.weekYear.week < $1.weekYear.week
            : $0.weekYear.year > $1.weekYear.year
        }
    }
}
