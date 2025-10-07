import XCTest
@testable import SolarSystemApp

class PlanetaryDataTests: XCTestCase {
    
    var planetaryDataManager: PlanetaryDataManager!
    
    override func setUp() {
        super.setUp()
        planetaryDataManager = PlanetaryDataManager.shared
    }
    
    override func tearDown() {
        planetaryDataManager = nil
        super.tearDown()
    }
    
    // MARK: - Mars Moon Count Tests
    func testMarsHasCorrectMoonCount() {
        // Given
        let expectedMoonCount = 2 // Phobos and Deimos
        
        // When
        let actualMoonCount = planetaryDataManager.getPlanetMoonCount(for: "Mars")
        
        // Then
        XCTAssertEqual(actualMoonCount, expectedMoonCount, "Mars should have 2 moons (Phobos and Deimos), not Jupiter's moon count")
    }
    
    func testMarsDataIsNotJupiterData() {
        // Given
        let mars = planetaryDataManager.getPlanet(named: "Mars")
        let jupiter = planetaryDataManager.getPlanet(named: "Jupiter")
        
        // When & Then
        XCTAssertNotNil(mars, "Mars data should exist")
        XCTAssertNotNil(jupiter, "Jupiter data should exist")
        
        if let mars = mars, let jupiter = jupiter {
            XCTAssertNotEqual(mars.moonCount, jupiter.moonCount, "Mars moon count should not equal Jupiter's moon count")
            XCTAssertEqual(mars.moonCount, 2, "Mars should have exactly 2 moons")
            XCTAssertEqual(jupiter.moonCount, 95, "Jupiter should have 95 known moons as of 2023")
        }
    }
    
    // MARK: - All Planet Moon Count Tests
    func testAllPlanetMoonCounts() {
        let expectedMoonCounts: [String: Int] = [
            "Mercury": 0,
            "Venus": 0,
            "Earth": 1,
            "Mars": 2,      // Fixed: Previously showing Jupiter's count
            "Jupiter": 95,   // As of 2023
            "Saturn": 146,   // As of 2023
            "Uranus": 27,
            "Neptune": 16
        ]
        
        for (planetName, expectedCount) in expectedMoonCounts {
            let actualCount = planetaryDataManager.getPlanetMoonCount(for: planetName)
            XCTAssertEqual(actualCount, expectedCount, "\(planetName) should have \(expectedCount) moons, but got \(actualCount)")
        }
    }
    
    // MARK: - Data Integrity Tests
    func testAllPlanetsExist() {
        let planetNames = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
        
        for planetName in planetNames {
            let planet = planetaryDataManager.getPlanet(named: planetName)
            XCTAssertNotNil(planet, "\(planetName) should exist in planetary data")
        }
    }
    
    func testPlanetsAreOrderedByDistanceFromSun() {
        // Given
        let planets = planetaryDataManager.getAllPlanets()
        
        // When & Then
        for i in 0..<planets.count - 1 {
            let currentPlanet = planets[i]
            let nextPlanet = planets[i + 1]
            XCTAssertLessThanOrEqual(currentPlanet.distanceFromSun, nextPlanet.distanceFromSun,
                                   "Planets should be ordered by distance from Sun. \(currentPlanet.name) (\(currentPlanet.distanceFromSun) AU) should come before \(nextPlanet.name) (\(nextPlanet.distanceFromSun) AU)")
        }
    }
    
    func testNonExistentPlanetReturnsNil() {
        // Given
        let nonExistentPlanet = "Pluto" // Sorry Pluto!
        
        // When
        let planet = planetaryDataManager.getPlanet(named: nonExistentPlanet)
        let moonCount = planetaryDataManager.getPlanetMoonCount(for: nonExistentPlanet)
        
        // Then
        XCTAssertNil(planet, "Non-existent planet should return nil")
        XCTAssertEqual(moonCount, 0, "Non-existent planet should return 0 moon count")
    }
}
