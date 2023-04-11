//
//  APIManager.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint, spaceX: Bool) async throws -> T
    func fetchPOD() async -> APIPod?
    func fetchLaunches() async -> [APILaunch]
}

final class APIManager: APIManaging {
    // Creating and configuring URL session
    private var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        
        return URLSession(configuration: config)
    }()
    
    func request(_ endpoint: Endpoint, spaceX: Bool) async throws -> Data {
        let request: URLRequest = try endpoint.asRequest(spaceX: spaceX)
        
        Logger.log("Requesting data from \(request.description)", .info)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.unacceptableResponseStatusCode
        }
        
        return data
    }
    // Requesting and decoding data to generic parameter T, returning data object
    func request<T: Decodable>(_ endpoint: Endpoint, spaceX: Bool) async throws -> T {
        let decoder = JSONDecoder()
        let data = try await request(endpoint, spaceX: spaceX)
        let object = try decoder.decode(T.self, from: data)
        
        return object
    }
    
    func fetchPOD() async -> APIPod? {
        let endPoint: PODRouter = .init()
        var pod: APIPod = .init()
        do {
            let response: APIPod = try await request(endPoint, spaceX: false)
            pod = response
        } catch {
            Logger.log("There has been problem fetching picture of the day from the API.\n\(error.localizedDescription)", .error)
        }
        return pod
    }
    
    func fetchLaunches() async -> [APILaunch] {
        var items: [APILaunch] = .init()
        let endpoint: LaunchesRouter = .init()
        do {
            let response: [APILaunch] = try await request(endpoint, spaceX: true)
            for item in response where { item.upcoming }() {
                items.append(item)
            }
        } catch {
            Logger.log("There has been problem fetching launches from the API.\n\(error)", .error)
        }
        return items
    }
}
