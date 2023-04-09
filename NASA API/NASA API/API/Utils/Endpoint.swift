//
//  Endpoint.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation
protocol Endpoint {
    var method: HTTPMethod { get }
    var urlParameters: [String: String]? { get }

    func asRequest(spaceX: Bool) throws -> URLRequest
}

extension Endpoint {
    var urlParameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }

    func asRequest(spaceX: Bool) throws -> URLRequest {
        // Getting base url, chat has a different baseURL
        var fullPath: URL
        if spaceX {
            fullPath = URLConstants.launchesURL
        } else {
            fullPath = URLConstants.podURL
        }
        
        // Checking the url components
        guard var components = URLComponents(url: fullPath, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidUrlComponents
        }
        
        if let parameters = urlParameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
            // Returns an array of parameters ([(language, en), ...])
        }
        
        guard let url = components.url else {
            throw APIError.invalidUrlComponents
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        request.setValue(HTTPHeader.ContentType.json.rawValue, forHTTPHeaderField: HTTPHeader.HeaderField.contentType.rawValue)
        
        return request
    }
}
