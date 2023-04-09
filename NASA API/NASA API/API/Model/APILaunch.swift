//
//  APILaunch.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//
// swiftlint:disable identifier_name

import Foundation

struct APILaunch {
    var fairings: Fairing?
    var links: Links?
    var static_fire_date_unix: Int?
    var net: Bool?
    var window: Int?
    var rocket: String?
    var success: Bool?
    var failures: [Failure]?
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
    var upcoming: Bool?
    var cores: [Core]
    var auto_update: Bool?
    var tbd: Bool?
    var id: String?
}

extension APILaunch: Decodable {}

struct Core: Decodable {
    var core: String?
    var flight: Int?
    var gridfins: Bool?
    var legs: Bool?
    var reused: Bool?
    var landing_attempt: Bool?
}

struct Fairing: Decodable {
    var reused: Bool?
    var recovery_attempt: Bool?
    var recovered: Bool?
    var ships: [String]?
}

struct PatchLink: Decodable {
    var small: URL?
    var large: URL?
}

struct RedditLink: Decodable {
    var campaign: URL?
    var launch: URL?
    var media: URL?
    var recovery: URL?
}

struct FlickrLink: Decodable {
    var small: [URL]?
    var original: [URL]?
}

struct Links: Decodable {
    var patch: PatchLink
    var reddit: RedditLink
    var flickr: FlickrLink
    var presskit: URL?
    var webcast: URL?
    var youtube_id: String?
    var article: URL?
    var wikipedia: URL?
}

struct Failure: Decodable {
    var time: Int?
    var altitude: Int?
    var reason: String?
}
