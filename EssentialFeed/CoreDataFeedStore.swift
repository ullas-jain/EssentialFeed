import CoreData

public final class CoreDataFeedStore {
    public static let modelName = "FeedStore"
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public struct ModelNotFound: Error {
        public let modelName: String
    }
    
    public init(storeURL: URL) throws {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        if let model = try? NSManagedObjectModel(name: "FeedStore", in: bundle) {
            container = try NSPersistentContainer.load(
                name: CoreDataFeedStore.modelName,
                model: model,
                url: storeURL
            )
            context = container.newBackgroundContext()
        } else {
            throw ModelNotFound(modelName: "FeedStore")
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toBeStored(in context: NSManagedObjectContext) throws -> NSOrderedSet {
        let managedImages = map { local in
            let image = ManagedFeedImage(context: context)
            image.id = local.id
            image.imageDescription = local.description
            image.location = local.location
            image.url = local.url
            return image
        }
        return NSOrderedSet(array: managedImages)
    }
}

private extension NSOrderedSet {
    var asLocal: [LocalFeedImage] {
        get throws {
            array.compactMap { stored in
                guard let stored = stored as? ManagedFeedImage else { return nil }
                return LocalFeedImage(id: stored.id, url: stored.url, description: stored.imageDescription, location: stored.location)
            }
        }
    }
}
