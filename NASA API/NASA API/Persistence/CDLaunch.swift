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
        self.payloads = .init()
        if let payloads = entity.payloads {
            for payload in payloads {
                self.payloads?.append(payload)
            }
        }
        self.upcoming = entity.upcoming
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
