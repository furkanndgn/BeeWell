//
//  CoreDataManager.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import Foundation
import CoreData
import Combine

class CoreDataManager: ObservableObject {
    
    static let shared = CoreDataManager()
    @Published var favoriteQuotes = [Quote]()
    @Published var lastSevenQuotes = [QuoteOfTheDay]()
    
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
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving staged changes \(String(describing: error)), \(error.userInfo)")
            }
        }
    }
    
//    MARK: Favorite Logic
    func getFavoriteQuotes() {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        do {
            favoriteQuotes = try context.fetch(fetchRequest)            
        } catch let error as NSError {
            print(String(describing: error), "on all quotes")
        }
    }
    
    func addToFavorites(_ quoteModel: QuoteModel) {
        let isSaved = checkIfFavorited(quoteModel)
        if !isSaved {
            let newQuote = Quote(context: context)
            newQuote.body = quoteModel.body
            newQuote.author = quoteModel.author
            newQuote.id = quoteModel.id
            newQuote.journal = quoteModel.journal
            newQuote.dateString = quoteModel.dateString
            saveContext()
        }
    }
    
    func checkIfFavorited(_ quoteModel: QuoteModel) -> Bool {
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
    
    func getQuoteFromFavorites(id: UUID) -> Quote? {
        var quote: Quote?
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", id.uuidString)
        fetchRequest.predicate = predicate
        do {
            quote = try context.fetch(fetchRequest).first(where: { $0.id == id })
        } catch let error as NSError {
            print("Error fetching quote, \(String(describing: error))")
        }
        return quote
    }
    
    func updateJournal(for quoteModel: QuoteModel) {
        let quoteAlreadyStored = checkIfFavorited(quoteModel)
        if quoteAlreadyStored {
            let quote = getQuoteFromFavorites(id: quoteModel.id)
            guard quote != nil else { return }
            quote!.journal = quoteModel.journal
            saveContext()
        } else {
            addToFavorites(quoteModel)
        }
    }
        
    func deleteQuoteFromFavorites(id: UUID) {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id==%@", id.uuidString)
        fetchRequest.predicate = predicate
        if let fetchedQuote = getQuoteFromFavorites(id: id) {
            context.delete(fetchedQuote)
            saveContext()
        }
    }
    
    func deleteFavoriteQuotes() {
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
    
//    MARK: Quotes of the last 7 days
    let calendar = Calendar.current
    
    func addQuoteOfTheDay(_ quote: QuoteModel) {
        let quoteOfTheDay = QuoteOfTheDay(context: context)
        quoteOfTheDay.id = quote.id
        quoteOfTheDay.author = quote.author
        quoteOfTheDay.body = quote.body
        quoteOfTheDay.date = calendar.startOfDay(for: Date())
        saveContext()
    }
    
    func fetchQuoteOfTheDay(date: Date) -> QuoteOfTheDay? {
        var quote: QuoteOfTheDay? = nil
        let fetchRequest: NSFetchRequest<QuoteOfTheDay> = QuoteOfTheDay.fetchRequest()
        let predicate = NSPredicate(format: "date==%@", calendar.startOfDay(for: date) as NSDate)
        fetchRequest.predicate = predicate
        do {
            quote = try context.fetch(fetchRequest).first(where: { $0.date ==  calendar.startOfDay(for: date)})
        } catch let error as NSError {
            print("Error fetching quote of the day, \(error.localizedDescription)")
        }
        return quote
    }
    
    func maintainQuoteLimitToSeven() {
        let sevenDaysAgo = calendar.date(byAdding: .day,value: -7, to: calendar.startOfDay(for: Date()))
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = QuoteOfTheDay.fetchRequest()
        let predicate = NSPredicate(format: "date<%@", sevenDaysAgo! as NSDate)
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
}
