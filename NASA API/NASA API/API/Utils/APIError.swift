//
//  APIError.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidUrlComponents
    case noResponse
    case unacceptableResponseStatusCode
    case customDecodingFailed
    case malformedUrl
}
