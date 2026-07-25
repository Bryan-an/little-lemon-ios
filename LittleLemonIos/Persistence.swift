import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ExampleDatabase")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: {_,_ in })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func clear() {
        // Delete all dishes from the store.
        //
        // A batch delete runs directly against the store and never tells the
        // context about it, so the deleted objects stay registered in memory and
        // keep turning up in fetch results next to the newly inserted ones -
        // every dish appears twice. Merging the deleted object IDs back into the
        // view context is what actually removes them from the object graph.
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        guard let result = try? container.persistentStoreCoordinator.execute(
            deleteRequest,
            with: container.viewContext
        ) as? NSBatchDeleteResult,
            let objectIDs = result.result as? [NSManagedObjectID]
        else { return }

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
            into: [container.viewContext]
        )
    }
}
