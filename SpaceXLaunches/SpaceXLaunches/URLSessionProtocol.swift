//
//  URLSessionProtocol.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 21/07/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
