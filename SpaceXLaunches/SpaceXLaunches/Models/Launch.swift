//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import Foundation
import SwiftUI

struct Launch: Codable {
    let links: Link
    let rocket: String
    var success: Bool?
    let details: String?
    let launchpad: String
    let upcoming: Bool
    let name: String
    let dateUtc: String
    let dateLocal: String
    let id: String
    
    // MARK: - Computed variables
    var utcDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: dateUtc) ?? Date.now
    }
    
    var localDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateLocal) ?? Date.now
    }

    var dateStringLocalTimeZone: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return dateFormatter.string(from: localDate)
    }

    var launchDateIrishTimeZone: Date {
        let irishTimeZone = TimeZone(identifier: "Europe/Dublin")!
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: irishTimeZone, from: utcDate)
        components.timeZone = irishTimeZone
        return calendar.date(from: components) ?? Date.now
    }

    var dateStringIrishTimeZone: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Dublin")
        return dateFormatter.string(from: launchDateIrishTimeZone)
    }
    
    // MARK: - Related Data
    struct Link: Codable {
        let patch: Patch
    }
                    
    struct Patch: Codable {
        let small: String?
        let large: String?
    }
    
    // MARK: - Sample Data for Preview
    static let sampleLaunch = Launch(
        links: Link(patch: Patch(
            small: "https://images2.imgbox.com/53/22/dh0XSLXO_o.png",
            large: "https://images2.imgbox.com/15/2b/NAcsTEB6_o.png")),
        rocket: "5e9d0d95eda69973a809d1ec",
        success: true,
        details: "SpaceX's 20th and final Crew Resupply Mission under the original NASA CRS contract, this mission brings essential supplies to the International Space Station using SpaceX's reusable Dragon spacecraft. It is the last scheduled flight of a Dragon 1 capsule. (CRS-21 and up under the new Commercial Resupply Services 2 contract will use Dragon 2.) The external payload for this mission is the Bartolomeo ISS external payload hosting platform. Falcon 9 and Dragon will launch from SLC-40, Cape Canaveral Air Force Station and the booster will land at LZ-1. The mission will be complete with return and recovery of the Dragon capsule and down cargo.",
        launchpad: "5e9e4501f509094ba4566f84", 
        upcoming: false,
        name: "CRS-20",
        dateUtc: "2020-03-07T04:50:31.000Z",
        dateLocal: "2020-03-06T23:50:31-05:00",
        id: "5eb87d42ffd86e000604b384")
}
