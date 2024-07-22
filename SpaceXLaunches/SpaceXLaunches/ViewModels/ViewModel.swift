//
//  ViewModel.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import Foundation
import SwiftUI

extension URLSession: URLSessionProtocol {}

@MainActor
class ViewModel: ObservableObject {
    
    @Published var launches = [Launch]()
    @Published var rocket: Rocket?
    @Published var launchpad: Launchpad?
    @Published var error: Error?
    
    private let session: URLSessionProtocol
    var endPoint = "https://api.spacexdata.com/v5/launches/"
    
    private var cachedPastLaunches = [Launch]()
    private var cachedUpcomingLaunches = [Launch]()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        loadCachedData()
        Task { await loadData(showPastLaunches: true) }
    }
    
    func loadCachedData() {
        loadLaunchPastFromJSON()
        loadLaunchUpcomingFromJSON()
        loadRocketInfoFromJSON()
        loadLaunchpadFromJSON()
    }
    
    func loadData(showPastLaunches: Bool) async {
        launches.removeAll()
        if showPastLaunches {
            if cachedPastLaunches.isEmpty {
                do {
                    try await fetchLaunchPastAsync()
                } catch {
                    handleOfflinePastLaunches()
                }
            } else {
                launches = cachedPastLaunches
            }
        } else {
            if cachedUpcomingLaunches.isEmpty {
                do {
                    try await fetchLaunchUpcomingAsync()
                } catch {
                    handleOfflineUpcomingLaunches()
                }
            } else {
                launches = cachedUpcomingLaunches
            }
        }
    }
            
    // MARK: - Past Launches
    func fetchLaunchPastAsync() async throws {
        do {
            guard let url = URL(string: "\(endPoint)past") else { throw SXError.invalidUrl }
            let (data, response) = try await session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                self.error = SXError.invalidResponse
                throw SXError.invalidResponse
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode([Launch].self, from: data)
            self.launches = result
            saveLaunchPastToJSON(launches: result)
        } catch _ as URLError {
            self.error = SXError.invalidUrl
            throw SXError.invalidUrl
        } catch _ as DecodingError {
            self.error = SXError.invalidData
            throw SXError.invalidData
        } catch {
            self.error = error
            //loadLaunchPastFromJSON()
            throw SXError.unknown(error)
        }
    }
    
    func saveLaunchPastToJSON(launches: [Launch]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(launches)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileUrl = documentsDirectory.appendingPathComponent("pastLaunches.json")
                try data.write(to: fileUrl)
            }
        } catch {
            self.error = error
        }
    }
    
    func loadLaunchPastFromJSON() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = documentDirectory.appendingPathComponent("pastLaunches.json")
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let data = try Data(contentsOf: fileUrl)
                    let decoder = JSONDecoder()
                    let launches = try decoder.decode([Launch].self, from: data)
                    DispatchQueue.main.async {
                        self.launches = launches
                    }
                } catch {
                    self.error = error
                }
            } else {
                print("JSON file does not exists.") //Message for Debugging only. Not for the user
            }
        }
    }
    
    func handleOfflinePastLaunches() {
        if cachedPastLaunches.isEmpty {
            loadLaunchPastFromJSON()
        } else {
            launches = cachedPastLaunches
        }
    }
    
    // MARK: - Upcoming Launches
    func fetchLaunchUpcomingAsync() async throws {
        do {
            guard let url = URL(string: "\(endPoint)upcoming") else { throw SXError.invalidUrl }
            let (data, response) = try await session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                self.error = SXError.invalidResponse
                throw SXError.invalidResponse
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let results = try decoder.decode([Launch].self, from: data)
            launches = results
            saveLaunchUpcomingToJSON(launches: results)
        } catch _ as URLError {
            self.error = SXError.invalidUrl
            throw SXError.invalidUrl
        } catch _ as DecodingError {
            self.error = SXError.invalidData
            throw SXError.invalidData
        } catch {
            self.error = error
            //loadLaunchUpcomingFromJSON()
            throw SXError.unknown(error)
        }
    }
    
    func saveLaunchUpcomingToJSON(launches: [Launch]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(launches)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileUrl = documentsDirectory.appendingPathComponent("upcomingLaunches.json")
                try data.write(to: fileUrl)
            }
        } catch {
            self.error = error
        }
    }
    
    func loadLaunchUpcomingFromJSON() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = documentDirectory.appendingPathComponent("upcomingLaunches.json")
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let data = try Data(contentsOf: fileUrl)
                    let decoder = JSONDecoder()
                    let launches = try decoder.decode([Launch].self, from: data)
                    DispatchQueue.main.async {
                        self.launches = launches
                    }
                } catch {
                    self.error = error
                }
            } else {
                print("JSON file does not exists.")
            }
        }
    }
    
    func handleOfflineUpcomingLaunches() {
        if cachedUpcomingLaunches.isEmpty {
            loadLaunchUpcomingFromJSON()
        } else {
            launches = cachedUpcomingLaunches
        }
    }
    
    // MARK: - Rocket Info
    func fetchRocketInfoAsync(withRocketId id: String) async throws {
        let rocketEndPoint = "https://api.spacexdata.com/v4/rockets/\(id)"
        do {
            guard let url = URL(string: rocketEndPoint) else { throw SXError.invalidUrl }
            let (data, response) = try await session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                self.error = SXError.invalidResponse
                throw SXError.invalidResponse
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(Rocket.self, from: data)
            self.rocket = result
            saveRocketInfoToJSON(rocket: result)
        } catch _ as URLError {
            self.error = SXError.invalidUrl
            throw SXError.invalidUrl
        } catch _ as DecodingError {
            self.error = SXError.invalidData
            throw SXError.invalidData
        } catch {
            self.error = error
            loadRocketInfoFromJSON()
            throw SXError.invalidData
        }
    }
    
    func saveRocketInfoToJSON(rocket: Rocket) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(rocket)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileUrl = documentsDirectory.appendingPathComponent("rocketInfo.json")
                try data.write(to: fileUrl)
            }
        } catch {
            self.error = error
        }
    }
    
    func loadRocketInfoFromJSON() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = documentDirectory.appendingPathComponent("rocketInfo.json")
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let data = try Data(contentsOf: fileUrl)
                    let decoder = JSONDecoder()
                    let rocket = try decoder.decode(Rocket.self, from: data)
                    DispatchQueue.main.async {
                        self.rocket = rocket
                    }
                } catch {
                    self.error = error
                }
            } else {
                print("JSON file does not exists.")
            }
        }
    }
    
    // MARK: - Launchpad Info
    func fetchLaunchpadInfoAsync(withLaunchpadId id: String) async throws {
        let launchpadEndPoint = "https://api.spacexdata.com/v4/launchpads/\(id)"
        do {
            guard let url = URL(string: launchpadEndPoint) else { throw SXError.invalidUrl }
            let (data, response) = try await session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                self.error = SXError.invalidResponse
                throw SXError.invalidResponse
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(Launchpad.self, from: data)
            self.launchpad = result
            saveLaunchpadToJSON(launchpad: result)
        } catch _ as URLError {
            self.error = SXError.invalidUrl
            throw SXError.invalidUrl
        } catch _ as DecodingError {
            self.error = SXError.invalidData
            throw SXError.invalidData
        } catch {
            self.error = error
            loadLaunchpadFromJSON()
            throw SXError.unknown(error)
        }
    }
    
    func saveLaunchpadToJSON(launchpad: Launchpad) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(launchpad)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileUrl = documentsDirectory.appendingPathComponent("launchpadInfo.json")
                try data.write(to: fileUrl)
            }
        } catch {
            self.error = error
        }
    }
    
    func loadLaunchpadFromJSON() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = documentDirectory.appendingPathComponent("launchpadInfo.json")
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let data = try Data(contentsOf: fileUrl)
                    let decoder = JSONDecoder()
                    let launchpad = try decoder.decode(Launchpad.self, from: data)
                    DispatchQueue.main.async {
                        self.launchpad = launchpad
                    }
                } catch {
                    self.error = error
                }
            } else {
                print("JSON file does not exists.")
            }
        }
    }
}
