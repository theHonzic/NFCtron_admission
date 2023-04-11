//
//  Launch.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

struct Launch {
    var id: String
    var name: String
    var launchDate: Date?
    var wikiURL: URL?
    var livestreamURL: URL?
    var patchURL: URL?
    var pinned: Bool
}

extension Launch {
    init(from entity: APILaunch) {
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        if let date = entity.date_unix {
            self.launchDate = .init(timeIntervalSince1970: .init(date))
        }
        if let wiki = entity.links?.wikipedia {
            self.wikiURL = .init(string: wiki)
        }
        if let livestream = entity.links?.webcast {
            self.livestreamURL = .init(string: livestream)
        }
        if let patch = entity.links?.patch.small {
            self.patchURL = .init(string: patch)
        }
        self.pinned = false
    }
    init(from entity: CDLaunch) {
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.launchDate = entity.launchDate
        self.wikiURL = .init(string: entity.wikiLink ?? "")
        self.livestreamURL = .init(string: entity.lstLink ?? "")
        self.pinned = entity.pinned
        self.patchURL = .init(string: entity.patch ?? "")
    }
}


#if DEBUG
extension Launch {
    static let mock = Launch(id:"312", name: "Starlink 4-34 (v1.5)", launchDate: .now, wikiURL: .init(string: "https://cs.wikipedia.org/wiki/Barnardova_šipka"), livestreamURL: .init(string: "https://www.youtube.com/watch?v=wBgSH-CGPzg"), patchURL: .init(string: "https://images2.imgbox.com/a9/9a/NXVkTZCE_o.png"), pinned: true)
}
#endif
