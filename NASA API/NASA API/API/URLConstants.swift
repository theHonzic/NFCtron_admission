//
//  URLConstants.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//
// swiftlint:disable force_unwrapping

import Foundation

enum URLConstants {
    static let podURL: URL = .init(string: "https://api.nasa.gov/planetary/apod")!
    static let launchesURL: URL = .init(string: "https://api.spacexdata.com/v4/launches")!
}
