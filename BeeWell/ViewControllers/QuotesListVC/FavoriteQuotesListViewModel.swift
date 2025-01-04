//
//  QuotesListViewModel.swift
//  BeeWell
//
//  Created by Furkan Doğan on 18.12.2024.
//

import Foundation

class FavoriteQuotesListViewModel {
    
    private let dataManager: FavoriteQuotesRepository
    private var favoriteQuotes = [QuoteModel]()
    private var groupedQuotes = [QuotesSection]()
    private var quoteCount: Int = 0
    static let currentYear = Calendar.current.component(.year, from: Date())
    var years: [Int] = []
    var selectedYear: Int?
    
    init(dataManager: FavoriteQuotesRepository = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    
    func getQuotesFor(year: Int? = currentYear) {
        favoriteQuotes = dataManager.getFavoriteQuotesOfYear(for: year!)
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
        getQuotesFor(year: selectedYear)
    }
    
    func setupYears() {
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(currentYear - 10...currentYear).sorted(by: { $0 > $1 })
        selectedYear = currentYear
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
