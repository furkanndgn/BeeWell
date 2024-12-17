//
//  CoreDataManager.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BeeWell")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unsolved error \(error), \(error.userInfo)")
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
                print("Error saving staged changes \(error), \(error.userInfo)")
            }
        }
    }
    
    func getJournal(from day: String) -> [Journal] {
        var journals = [Journal]()
        var fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        var predicate = NSPredicate(format: "dateString=%@", day)
        fetchRequest.predicate = predicate
        do {
            journals = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return journals
    }
    
    func getAllQuotes() -> [Quote] {
        var quotes = [Quote]()
        var fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        do {
            quotes = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return quotes
    }
    
    func addNewJournal(content: String, date: Date, id: UUID, type: String) {
        let journal = Journal(context: context)
        journal.content = content
        journal.dateString = date.toDayString()
        journal.id = id
        journal.type = type
        saveContext()
    }
    
    func addNewQuote(content: String, author: String, id: UUID) {
        let quote = Quote(context: context)
        quote.content = content
        quote.author = author
        quote.id = id
        saveContext()
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
}
