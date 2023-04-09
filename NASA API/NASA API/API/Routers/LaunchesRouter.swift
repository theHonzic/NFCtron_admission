//
//  LaunchesRouter.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

struct LaunchesRouter: Endpoint {
    var urlParameters: [String : String]? = {
        return nil
    }()

    var method: HTTPMethod = {
        return .get
    }()
}
