//
//  PODRouter.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

struct PODRouter: Endpoint {
    var path: URL {
        return URLConstants.podURL
    }
    
    var urlParameters: [String: String]? = {
        return ["api_key": "XGLlFo3nUkLC9ehBISGEG0dFsNxKMabxfM2E8aIO"]
    }()
}
