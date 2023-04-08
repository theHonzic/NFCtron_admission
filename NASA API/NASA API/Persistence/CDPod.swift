//
//  CDPod.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import Foundation
import CoreData
import UIKit

extension CDPod {
    convenience init(from entity: APIPod, in context: NSManagedObjectContext) async {
        self.init(context: context)
        
        self.id = UUID()
        self.title = entity.title
        self.explanation = entity.explanation
        self.url = entity.url?.description
        self.hdUrl = entity.hdurl?.description
        
        if let date = entity.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: date) else {
                Logger.log("Could not convert date.", .error)
                return
            }
            self.posted = date
        }
        
        if let url = entity.url {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.thumbnailImage = UIImage(data: data)?.pngData()
            } catch {
                Logger.log(error.localizedDescription, .error)
            }
        }
        
        if let url = entity.hdurl {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.fullPicture = UIImage(data: data)?.pngData()
            } catch {
                Logger.log(error.localizedDescription, .error)
            }
        }
        
        do {
            try context.save()
        } catch {
            Logger.log("Unable to save POD to Core Data.\n\(error.localizedDescription)", .error)
        }
    }
}
