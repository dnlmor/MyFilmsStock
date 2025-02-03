import CoreData
import os.log

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    private let logger = Logger(subsystem: "com.yourapp.myfilms", category: "CoreData")
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "myfilms")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { [weak self] (storeDescription, error) in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                self.logger.error("Unresolved Core Data loading error: \(error.localizedDescription)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func deleteFilm(film: Film) {
        let context = container.viewContext
        context.performAndWait {
            context.delete(film)
            saveContext()
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            logger.error("Unresolved Core Data save error: \(nsError.localizedDescription)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
