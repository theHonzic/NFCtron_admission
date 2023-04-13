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
    func asRequest() throws -> URLRequest
    var path: URL { get }
}

extension Endpoint {
    var urlParameters: [String: Any]? {
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    var headers: [String: String]? {
        return nil
    }

    func asRequest() throws -> URLRequest {
        // Checking the url components
        guard var components = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidUrlComponents
        }
        
        if let parameters = urlParameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
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
