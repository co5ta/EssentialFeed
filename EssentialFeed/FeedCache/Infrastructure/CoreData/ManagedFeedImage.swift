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
    @NSManaged var cache: ManagedCache

    static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: feed.map { localFeed in
            let managedFeedImage = ManagedFeedImage(context: context)
            managedFeedImage.id = localFeed.id
            managedFeedImage.imageDescription = localFeed.description
            managedFeedImage.location = localFeed.location
            managedFeedImage.url = localFeed.url
            return managedFeedImage
        })
    }

    var localFeedImage: LocalFeedImage {
        return LocalFeedImage(
            id: id,
            description: imageDescription,
            location: location,
            url: url)
    }
}
