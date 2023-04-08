//
//  Pod.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import Foundation

struct APIPod: Decodable {
    var title: String?
    var explanation: String?
    var url: URL?
    var hdurl: URL?
    var date: String?
}
