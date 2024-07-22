//
//  Rocket.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import Foundation

struct Rocket: Codable {
    let name: String
    let description: String
    let id: String
    let flickrImages: [String]
    
    
    // MARK: - Sample data for preview 
    static let sampleRocket = Rocket(
        name: "Falcon Heavy",
        description: "With the ability to lift into orbit over 54 metric tons (119,000 lb)--a mass equivalent to a 737 jetliner loaded with passengers, crew, luggage and fuel--Falcon Heavy can lift more than twice the payload of the next closest operational vehicle, the Delta IV Heavy, at one-third the cost.",
        id: "5e9d0d95eda69974db09d1ed",
        flickrImages: ["https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg"]
    )
}
