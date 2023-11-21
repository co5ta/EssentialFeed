//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 01/05/2023.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        return try first(with: url, in: context)?.data
    }

    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedFeedImage? {
        let request = NSFetchRequest<ManagedFeedImage>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedImage.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let images = NSOrderedSet(array: feed.map { localFeed in
            let managedFeedImage = ManagedFeedImage(context: context)
            managedFeedImage.id = localFeed.id
            managedFeedImage.imageDescription = localFeed.description
            managedFeedImage.location = localFeed.location
            managedFeedImage.url = localFeed.url
            managedFeedImage.data = context.userInfo[localFeed.url] as? Data
            return managedFeedImage
        })
        context.userInfo.removeAllObjects()
        return images
    }

    var localFeedImage: LocalFeedImage {
        return LocalFeedImage(
            id: id,
            description: imageDescription,
            location: location,
            url: url)
    }

    override func prepareForDeletion() {
        super.prepareForDeletion()

        managedObjectContext?.userInfo[url] = data
    }
}
