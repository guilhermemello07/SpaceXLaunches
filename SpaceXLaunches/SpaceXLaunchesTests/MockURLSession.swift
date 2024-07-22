//
//  MockURLSession.swift
//  SpaceXLaunchesTests
//
//  Created by Guilherme Teixeira de Mello on 21/07/24.
//

import Foundation
@testable import SpaceXLaunches

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data ?? Data(), response)
    }
}
