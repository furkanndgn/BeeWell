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
    @Published var fetchedQuotes = [Quote]()
    
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
    
//    func getJournal(from day: String) -> [Journal] {
//        var journals = [Journal]()
//        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
//        let predicate = NSPredicate(format: "dateString=%@", day)
//        fetchRequest.predicate = predicate
//        do {
//            journals = try context.fetch(fetchRequest)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return journals
//    }
    
    func getAllQuotes() {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        do {
            fetchedQuotes = try context.fetch(fetchRequest)            
        } catch let error as NSError {
            print(String(describing: error), "on all quotes")
        }
    }
    
    func addNewQuote(_ quoteModel: QuoteModel) {
        let isSaved = checkIfAlreadyStored(quoteModel: quoteModel)
        if !isSaved {
            let newQuote = Quote(context: context)
            newQuote.content = quoteModel.quote
            newQuote.author = quoteModel.author
            newQuote.id = quoteModel.id
            newQuote.journal = quoteModel.journal
            newQuote.dateString = quoteModel.dateString
            saveContext()
        }
    }
    
    func checkIfAlreadyStored(quoteModel: QuoteModel) -> Bool{
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "content=%@", quoteModel.quote)
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
    
    func getQuote(dateString: String) -> Quote? {
        var quote: Quote?
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "dateString==%@", dateString)
        fetchRequest.predicate = predicate
        do {
            quote = try context.fetch(fetchRequest).first(where: { $0.dateString == dateString })
        } catch let error as NSError {
            print("Error fetching quote, \(String(describing: error))")
        }
        return quote
    }
    
    func updateJournal(quoteModel: QuoteModel) {
        let quote = getQuote(dateString: quoteModel.dateString)
        guard quote != nil else { return }
        quote!.journal = quoteModel.journal
        saveContext()
    }
        
    func deleteQuote(dateString: String) {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "dateString==%@", dateString)
        fetchRequest.predicate = predicate
        do {
            if let fetchedQuote = try context.fetch(fetchRequest).first(where: { $0.dateString == dateString }) {
                context.delete(fetchedQuote)
                saveContext()
            }
        } catch let error as NSError {
            print("Error deleting quote, \(error.userInfo), \(error.localizedDescription)")
        }
    }
    
    func deleteAllQuotes() {
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
}
