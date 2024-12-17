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
    
    func addNewJournal(content: String, dateString: String, id: UUID, quoteID: UUID) {
        let journal = Journal(context: context)
        journal.content = content
        journal.dateString = dateString
        journal.id = id
        journal.quoteID = quoteID
        saveContext()
    }
    
    func addNewQuote(_ quoteModel: QuoteModel) {
        let isSaved = checkIfAlreadyStored(quoteModel: quoteModel)
        if !isSaved {
            let newQuote = Quote(context: context)
            newQuote.content = quoteModel.quote
            newQuote.author = quoteModel.author
            newQuote.id = quoteModel.id
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
    
    func deleteJournal(id: UUID) {
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        let predicate = NSPredicate(format: "id=%@", id.uuidString)
        fetchRequest.predicate = predicate
        do {
            if let fetchedJournal = try context.fetch(fetchRequest).first(where: { $0.id == id }) {
                context.delete(fetchedJournal)
                saveContext()
            }
        } catch let error as NSError {
            print("Error deleting journal, \(error.userInfo), \(error.localizedDescription)")
        }
    }
    
    func deleteQuote(id: UUID) {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let predicate = NSPredicate(format: "id=%@", id.uuidString)
        fetchRequest.predicate = predicate
        do {
            if let fetchedQuote = try context.fetch(fetchRequest).first(where: { $0.id == id }) {
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
