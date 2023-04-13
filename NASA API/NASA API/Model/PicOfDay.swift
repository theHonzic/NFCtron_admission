//
//  PicOfDay.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import Foundation

struct PicOfDay {
    var title: String
    var explanation: String
    var date: Date?
    var url: URL?
    var hdURL: URL?
    var imageData: Data?
}

extension PicOfDay {
    init(from entity: APIPod) {
        self.title = entity.title ?? "Unknown"
        self.explanation = entity.explanation ?? "There is no explanation."
        if let date = entity.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: date) else {
                Logger.log("Could not convert date.", .error)
                return
            }
            self.date = date
        }
        self.url = entity.url
        self.hdURL = entity.hdurl
    }
    
    init(from entity: CDPod) {
        self.title = entity.title ?? "Unknown"
        self.explanation = entity.explanation ?? "There is no explanation."
        self.date = entity.posted
        if let url = entity.url {
            self.url = .init(string: url)
        }
        if let url = entity.hdUrl {
            self.hdURL = .init(string: url)
        }
        if let data = entity.fullPicture {
            self.imageData = data
        }
    }
}
