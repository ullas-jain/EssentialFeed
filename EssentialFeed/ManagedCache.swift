import Foundation
import CoreData

final class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet

    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let fetchRequest = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        fetchRequest.returnsObjectsAsFaults = false
        return try context.fetch(fetchRequest).first
    }
}
