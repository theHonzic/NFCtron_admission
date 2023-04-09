//
//  NetworkManager.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import Foundation
import Network

final class NetworkManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "cz.mendelu.NASA-API.newtworkManager")
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}
