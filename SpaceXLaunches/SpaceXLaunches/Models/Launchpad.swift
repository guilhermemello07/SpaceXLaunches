//
//  Launchpad.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import Foundation

struct Launchpad: Codable {
    let fullName: String
    let locality: String
    let region: String
    let latitude: Double
    let longitude: Double
    let details: String
    let id: String
    
    
    // MARK: - Sample data for preview 
    static let sampleLaunchPad = Launchpad(
        fullName: "Landing Zone 2", 
        locality: "Cape Canaveral",
        region: "Florida",
        latitude: 28.485833,
        longitude: -80.544444, 
        details: "SpaceX's first east coast landing pad is Landing Zone 1, where the historic first Falcon 9 landing occurred in December 2015. LC-13 was originally used as a launch pad for early Atlas missiles and rockets from Lockheed Martin. LC-1 was later expanded to include Landing Zone 2 for side booster RTLS Falcon Heavy missions, and it was first used in February 2018 for that purpose.",
        id: "5e9e3032383ecb90a834e7c8")
}
