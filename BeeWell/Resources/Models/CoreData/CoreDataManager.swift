//
//  CoreDataManager.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import Foundation
import CoreData

class CoreDataManager: HomeScreenQuotesRepository {

    static let shared = CoreDataManager()
    var favoriteQuotes = [QuoteModel]()
    var lastSevenQuotes = [QuoteModel]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BeeWell")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Persistent store error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving staged changes \(String(describing: error)), \(error.userInfo)")
            }
        }
    }
    
//    MARK: Favorite Logic
    func getAllFavoriteQuotes() -> [QuoteModel] {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        do {
            favoriteQuotes = try context.fetch(fetchRequest).map(QuoteModel.init)
        } catch let error as NSError {
            print(String(describing: error), "on all quotes")
        }
        return favoriteQuotes
    }
    
    func getFavoriteQuotesOfYear(for year: Int) -> [QuoteModel] {
        let startDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1))! as NSDate
        let endDate = calendar.date(from: DateComponents(year: year, month: 12, day: 31))! as NSDate
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "date >= %@ and date <= %@", startDate, endDate)
        fetchRequest.predicate = predicate
        do {
            favoriteQuotes = try context.fetch(fetchRequest).map(QuoteModel.init)
        } catch let error as NSError {
            print(String(describing: error), "fetching favorite quotes of year.")
        }
        return favoriteQuotes
    }
    
    func addToFavorites(_ quoteModel: QuoteModel) {
        let isSaved = checkIfQuoteFavorited(for: quoteModel)
        if !isSaved {
            let newQuote = Quote(context: context)
            newQuote.body = quoteModel.body
            newQuote.author = quoteModel.author
            newQuote.id = quoteModel.id
            newQuote.journal = quoteModel.journal
            newQuote.date = quoteModel.date
            saveContext()
        }
    }
    
    func checkIfQuoteFavorited(for quoteModel: QuoteModel) -> Bool {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", quoteModel.id.uuidString)
        var isAlreadySaved: Bool = true
        fetchRequest.predicate = predicate
        do {
            let fetchedQuotes = try context.fetch(fetchRequest)
            isAlreadySaved = !fetchedQuotes.isEmpty
        } catch let error as NSError {
            print("Error checking store, \(String(describing: error)), \(error.localizedDescription)")
        }
        return isAlreadySaved
    }
    
    func getQuoteFromFavorites(with id: UUID) -> QuoteModel? {
        var quote: Quote?
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        fetchRequest.predicate = predicate
        do {
            quote = try context.fetch(fetchRequest).first(where: { $0.id == id })
        } catch let error as NSError {
            print("Error fetching quote, \(String(describing: error))")
        }
        return quote.map(QuoteModel.init)
    }
    
    func updateJournal(of quoteModel: QuoteModel) {
        let quoteAlreadyStored = checkIfQuoteFavorited(for: quoteModel)
        if quoteAlreadyStored {
            let quote = fetchQuote(with: quoteModel.id)
            guard quote != nil else { return }
            quote!.journal = quoteModel.journal
            saveContext()
        } else {
            addToFavorites(quoteModel)
        }
    }
        
    func removeFromFavorites(_ quoteModel: QuoteModel) {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", quoteModel.id.uuidString)
        fetchRequest.predicate = predicate
        if let fetchedQuote = fetchQuote(with: quoteModel.id) {
            context.delete(fetchedQuote)
            saveContext()
        }
    }
    
    func deleteAllFavorites() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Quote.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("Successfully deleted all quotes.")
        } catch {
            print("Error deleting all quotes: \(error.localizedDescription)")
        }
    }
    
//    Helper functions
    private func fetchQuote(with id: UUID) -> Quote? {
        var quote: Quote?
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        fetchRequest.predicate = predicate
        do {
            quote = try context.fetch(fetchRequest).first(where: { $0.id == id })
        } catch let error as NSError {
            print("Error fetching quote, \(String(describing: error))")
        }
        return quote
    }
    
//    MARK: Quotes of the last 7 days
    let calendar = Calendar.current
    
    func saveQuoteOfTheDay(_ quoteModel: QuoteModel) {
        let quoteOfTheDay = QuoteOfTheDay(context: context)
        quoteOfTheDay.id = quoteModel.id
        quoteOfTheDay.author = quoteModel.author
        quoteOfTheDay.body = quoteModel.body
        quoteOfTheDay.date = calendar.startOfDay(for: Date().toCSTTime())
        saveContext()
    }
    
    func getQuoteOfTheDay(for date: Date) -> QuoteModel? {
        var quote: QuoteOfTheDay? = nil
        let fetchRequest: NSFetchRequest<QuoteOfTheDay> = QuoteOfTheDay.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", calendar.startOfDay(for: date) as NSDate)
        fetchRequest.predicate = predicate
        do {
            quote = try context.fetch(fetchRequest).first(where: { $0.date ==  calendar.startOfDay(for: date)})
        } catch let error as NSError {
            print("Error fetching quote of the day, \(error.localizedDescription)")
        }
        return quote.map(QuoteModel.init)
    }
    
    func maintainQuoteLimit() {
        let sevenDaysAgo = calendar.date(byAdding: .day,value: -7, to: calendar.startOfDay(for: Date().toCSTTime()))
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = QuoteOfTheDay.fetchRequest()
        let predicate = NSPredicate(format: "date < %@", sevenDaysAgo! as NSDate)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("Deleted excess quotes.")
        } catch let error as NSError {
            print("Error deleting excess error, \(error.localizedDescription)")
        }
    }
    
//    MARK: For development purposes
    func fetchQuoteOfThe7Days() {
        let fetchRequest: NSFetchRequest<QuoteOfTheDay> = QuoteOfTheDay.fetchRequest()
        do {
            lastSevenQuotes = try context.fetch(fetchRequest).map(QuoteModel.init)
            lastSevenQuotes.forEach { quote in
                print(quote.date)
            }
        } catch let error as NSError {
            print("Error fetching last 7 days QOTD. \(error.userInfo), \(error.localizedDescription)")
        }
    }
    
    func deleteStoredQuoteOfTheDays() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = QuoteOfTheDay.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch let error as NSError {
            print("Error deleting all QOTDs. \(error.userInfo), \(error.localizedDescription)")
        }
    }
}
