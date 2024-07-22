//
//  SXError.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import Foundation


enum SXError: Error, LocalizedError, Equatable {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unknown(Error)
    
    static func == (lhs: SXError, rhs: SXError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "There was an error accessing the resource, please check your internet connection and try again."
        case .invalidResponse:
            return "There was an error with the server. Please try again later."
        case .invalidData:
            return "The data is invalid. Please try again later."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

