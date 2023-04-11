//
//  CDLaunch.swift
//  NASA API
//
//  Created by Jan Janovec on 11.04.2023.
//

import CoreData
import Foundation

extension CDLaunch {
    convenience init(from entity: APILaunch, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = entity.id
        self.name = entity.name
        self.wikiLink = entity.links?.wikipedia
        self.patch = entity.links?.patch.small
        self.pinned = false
        if let date = entity.date_unix {
            self.launchDate = .init(timeIntervalSince1970: .init(date))
        }
        self.lstLink = entity.links?.webcast
        do {
            try context.save()
        } catch {
            Logger.log("Unable to save Launch to Core Data.\n\(error)", .error)
        }
    }
}
