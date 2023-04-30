//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 29/04/2023.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform { [context] in
            let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
            request.returnsObjectsAsFaults = false

            do {
                guard let managedCache = try context.fetch(request).first else {
                    return completion(.empty)
                }
                let localFeed = managedCache.feed
                    .compactMap { $0 as? ManagedFeedImage }
                    .map { managedFeedImage in
                    let localFeedImage = LocalFeedImage(
                        id: managedFeedImage.id,
                        description: managedFeedImage.imageDescription,
                        location: managedFeedImage.location,
                        url: managedFeedImage.url)
                    return localFeedImage
                }
                completion(.found(feed: localFeed, timestamp: managedCache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        context.perform { [context] in
            let managedCache = ManagedCache(context: context)
            managedCache.timestamp = timestamp
            managedCache.feed = NSOrderedSet(array: feed.map { localFeed in
                let managedFeedImage = ManagedFeedImage(context: context)
                managedFeedImage.id = localFeed.id
                managedFeedImage.imageDescription = localFeed.description
                managedFeedImage.location = localFeed.location
                managedFeedImage.url = localFeed.url
                managedFeedImage.cache = managedCache
                return managedFeedImage
            })

            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

    }
}

private extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }

    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }

        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }

        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

@objc(ManagedFeedImage)
private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}
