//
//  HTTPHeader.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

enum HTTPHeader {
    enum HeaderField: String {
        case contentType = "Content-Type"
    }

    enum ContentType: String {
        case json = "application/json"
        case htmlText = "text/html;charset=utf-8"
        case plainText = "text/plain; charset=utf-8"
    }
}
