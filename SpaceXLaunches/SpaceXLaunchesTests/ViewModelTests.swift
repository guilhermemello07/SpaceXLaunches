import XCTest
@testable import SpaceXLaunches

@MainActor
final class ViewModelTests: XCTestCase {
    
    var viewModel: ViewModel!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        viewModel = ViewModel(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockSession = nil
    }
    
    
    // MARK: - Launches tests
    func testFetchLaunchPastAsync_success() async throws {
        let mockData = """
        [
            {
                "links": {
                    "patch": {
                        "small": "https://images2.imgbox.com/53/22/dh0XSLXO_o.png",
                        "large": "https://images2.imgbox.com/15/2b/NAcsTEB6_o.png"
                    }
                },
                "rocket": "5e9d0d95eda69973a809d1ec",
                "success": true,
                "details": "SpaceX's 20th and final Crew Resupply Mission under the original NASA CRS contract...",
                "launchpad": "5e9e4501f509094ba4566f84",
                "upcoming": false,
                "name": "CRS-20",
                "dateUtc": "2020-03-07T04:50:31.000Z",
                "dateLocal": "2020-03-06T23:50:31-05:00",
                "id": "5eb87d42ffd86e000604b384"
            }
        ]
        """.data(using: .utf8)!
        
        mockSession.data = mockData
        try await viewModel.fetchLaunchPastAsync()
        
        XCTAssertEqual(viewModel.launches.count, 1)
        XCTAssertEqual(viewModel.launches.first?.name, "CRS-20")
    }
    
    func testFetchLaunchPastAsync_withInvalidURL() async throws {
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        
        viewModel.endPoint = "invalid_url"
        
        do {
            try await viewModel.fetchLaunchPastAsync()
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidUrl)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchLaunchPastAsync_withInvalidJSON() async throws {
        let invalidData = "not a valid JSON".data(using: .utf8)!
        mockSession.data = invalidData
        
        do {
            try await viewModel.fetchLaunchPastAsync()
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidData, "Expected SXError.invalidData but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Rocket tests
    func testFetchRocketInfoAsync_withValidData() async throws {
        let validData = """
        {
            "name": "Falcon Heavy",
            "description": "With the ability to lift into orbit over 54 metric tons (119,000 lb)--a mass equivalent to a 737 jetliner loaded with passengers, crew, luggage and fuel--Falcon Heavy can lift more than twice the payload of the next closest operational vehicle, the Delta IV Heavy, at one-third the cost.",
            "id": "5e9d0d95eda69974db09d1ed",
            "flickr_images": ["https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg"]
        }
        """.data(using: .utf8)!
        mockSession.data = validData
        
        let validRocketId = "5e9d0d95eda69974db09d1ed"
        
        try await viewModel.fetchRocketInfoAsync(withRocketId: validRocketId)
        
        XCTAssertEqual(viewModel.rocket?.name, "Falcon Heavy")
        XCTAssertEqual(viewModel.rocket?.description, "With the ability to lift into orbit over 54 metric tons (119,000 lb)--a mass equivalent to a 737 jetliner loaded with passengers, crew, luggage and fuel--Falcon Heavy can lift more than twice the payload of the next closest operational vehicle, the Delta IV Heavy, at one-third the cost.")
        XCTAssertEqual(viewModel.rocket?.id, "5e9d0d95eda69974db09d1ed")
        XCTAssertEqual(viewModel.rocket?.flickrImages.first, "https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg")
    }
    
    func testFetchRocketInfoAsync_withInvalidURL() async throws {
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        
        let invalidRocketId = "invalid_id"
        
        do {
            try await viewModel.fetchRocketInfoAsync(withRocketId: invalidRocketId)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidUrl, "Expected SXError.invalidUrl but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRocketInfoAsync_withInvalidJSON() async throws {
        let invalidData = "not a valid JSON".data(using: .utf8)!
        mockSession.data = invalidData
        
        let validRocketId = "5e9d0d95eda69974db09d1ed"
        
        do {
            try await viewModel.fetchRocketInfoAsync(withRocketId: validRocketId)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidData, "Expected SXError.invalidData but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRocketInfoAsync_withNetworkError() async throws {
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        let validRocketId = "5e9d0d95eda69974db09d1ed"
        
        do {
            try await viewModel.fetchRocketInfoAsync(withRocketId: validRocketId)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidUrl, "Expected SXError.invalidUrl but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRocketEncodingDecoding() throws {
        let rocket = Rocket(
            name: "Falcon Heavy",
            description: "With the ability to lift into orbit over 54 metric tons (119,000 lb)--a mass equivalent to a 737 jetliner loaded with passengers, crew, luggage and fuel--Falcon Heavy can lift more than twice the payload of the next closest operational vehicle, the Delta IV Heavy, at one-third the cost.",
            id: "5e9d0d95eda69974db09d1ed",
            flickrImages: ["https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg"]
        )
        let encoder = JSONEncoder()
        let data = try encoder.encode(rocket)
        let decoder = JSONDecoder()
        let decodedRocket = try decoder.decode(Rocket.self, from: data)
        XCTAssertEqual(rocket.name, decodedRocket.name)
    }
    
    // MARK: - Launchpad tests
    func testFetchLaunchpadInfoAsync_withValidData() async throws {
        let validData = """
        {
            "full_name": "Landing Zone 2",
            "locality": "Cape Canaveral",
            "region": "Florida",
            "latitude": 28.485833,
            "longitude": -80.544444,
            "details": "SpaceX's first east coast landing pad is Landing Zone 1, where the historic first Falcon 9 landing occurred in December 2015. LC-13 was originally used as a launch pad for early Atlas missiles and rockets from Lockheed Martin. LC-1 was later expanded to include Landing Zone 2 for side booster RTLS Falcon Heavy missions, and it was first used in February 2018 for that purpose.",
            "id": "5e9e3032383ecb90a834e7c8"
        }
        """.data(using: .utf8)!
        mockSession.data = validData
        
        let validLaunchpadId = "5e9e3032383ecb90a834e7c8"
        
        try await viewModel.fetchLaunchpadInfoAsync(withLaunchpadId: validLaunchpadId)
        
        XCTAssertEqual(viewModel.launchpad?.fullName, "Landing Zone 2")
        XCTAssertEqual(viewModel.launchpad?.locality, "Cape Canaveral")
        XCTAssertEqual(viewModel.launchpad?.region, "Florida")
        XCTAssertEqual(viewModel.launchpad?.latitude, 28.485833)
        XCTAssertEqual(viewModel.launchpad?.longitude, -80.544444)
        XCTAssertEqual(viewModel.launchpad?.details, "SpaceX's first east coast landing pad is Landing Zone 1, where the historic first Falcon 9 landing occurred in December 2015. LC-13 was originally used as a launch pad for early Atlas missiles and rockets from Lockheed Martin. LC-1 was later expanded to include Landing Zone 2 for side booster RTLS Falcon Heavy missions, and it was first used in February 2018 for that purpose.")
        XCTAssertEqual(viewModel.launchpad?.id, "5e9e3032383ecb90a834e7c8")
    }
    
    func testFetchLaunchpadInfoAsync_withInvalidURL() async throws {
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        
        let invalidLaunchpadId = "invalid_id"
        
        do {
            try await viewModel.fetchLaunchpadInfoAsync(withLaunchpadId: invalidLaunchpadId)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidUrl, "Expected SXError.invalidUrl but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchLaunchpadInfoAsync_withInvalidJSON() async throws {
        let invalidData = "not a valid JSON".data(using: .utf8)!
        mockSession.data = invalidData
        
        let validLaunchpadId = "5e9e3032383ecb90a834e7c8"
        
        do {
            try await viewModel.fetchLaunchpadInfoAsync(withLaunchpadId: validLaunchpadId)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidData, "Expected SXError.invalidData but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchLaunchpadInfoAsync_withNetworkError() async throws {
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        let validLaunchpadId = "5e9e3032383ecb90a834e7c8"
        
        do {
            try await viewModel.fetchLaunchpadInfoAsync(withLaunchpadId: validLaunchpadId)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as SXError {
            XCTAssertEqual(error, SXError.invalidUrl, "Expected SXError.invalidUrl but got: \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
