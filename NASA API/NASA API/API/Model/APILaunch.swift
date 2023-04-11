//
//  APILaunch.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//
// swiftlint:disable identifier_name

import Foundation

struct APILaunch: Decodable {
    var fairings: APIFairing?
    var links: APILinks?
    var static_fire_date_unix: Int?
    var net: Bool?
    var window: Int?
    var rocket: String?
    var success: Bool?
    var failures: [APIFailure]
    var details: String?
    var crew: [String]?
    var ships: [String]?
    var capsules: [String]?
    var payloads: [String]?
    var launchpad: String?
    var flight_number: Int?
    var name: String?
    var date_unix: Int?
    var date_precision: String?
    var upcoming: Bool
    var cores: [APICore]
    var auto_update: Bool?
    var tbd: Bool?
    var id: String?
}

struct APICore: Decodable {
    var core: String?
    var flight: Int?
    var gridfins: Bool?
    var legs: Bool?
    var reused: Bool?
    var landing_attempt: Bool?
}

struct APIFairing: Decodable {
    var reused: Bool?
    var recovery_attempt: Bool?
    var recovered: Bool?
    var ships: [String]?
}

struct APIPatchLink: Decodable {
    var small: String?
    var large: String?
}

struct APIRedditLink: Decodable {
    var campaign: String?
    var launch: String?
    var media: String?
    var recovery: String?
}

struct APIFlickrLink: Decodable {
    var small: [String]?
    var original: [String]?
}

struct APILinks: Decodable {
    var patch: APIPatchLink
    var reddit: APIRedditLink
    var flickr: APIFlickrLink
    var presskit: String?
    var webcast: String?
    var youtube_id: String?
    var article: String?
    var wikipedia: String?
}

struct APIFailure: Decodable {
    var time: Int?
    var altitude: Int?
    var reason: String?
}
