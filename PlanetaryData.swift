import Foundation

// MARK: - Planet Data Model
struct Planet {
    let name: String
    let moonCount: Int
    let distanceFromSun: Double // in AU (Astronomical Units)
    let diameter: Double // in kilometers
    let description: String
}

// MARK: - Planetary Data Manager
class PlanetaryDataManager {
    static let shared = PlanetaryDataManager()
    
    private init() {}
    
    // MARK: - Planet Data
    private let planets: [String: Planet] = [
        "Mercury": Planet(
            name: "Mercury",
            moonCount: 0,
            distanceFromSun: 0.39,
            diameter: 4879,
            description: "The smallest planet and closest to the Sun"
        ),
        "Venus": Planet(
            name: "Venus",
            moonCount: 0,
            distanceFromSun: 0.72,
            diameter: 12104,
            description: "The hottest planet with a thick atmosphere"
        ),
        "Earth": Planet(
            name: "Earth",
            moonCount: 1,
            distanceFromSun: 1.0,
            diameter: 12756,
            description: "Our home planet with abundant water and life"
        ),
        "Mars": Planet(
            name: "Mars",
            moonCount: 2, // Phobos and Deimos - FIXED: Was incorrectly showing Jupiter's moon count
            distanceFromSun: 1.52,
            diameter: 6792,
            description: "The red planet with polar ice caps and evidence of ancient water"
        ),
        "Jupiter": Planet(
            name: "Jupiter",
            moonCount: 95, // As of 2023, including the four major Galilean moons
            distanceFromSun: 5.20,
            diameter: 142984,
            description: "The largest planet with a Great Red Spot storm"
        ),
        "Saturn": Planet(
            name: "Saturn",
            moonCount: 146, // As of 2023, including Titan and Enceladus
            distanceFromSun: 9.58,
            diameter: 120536,
            description: "Known for its prominent ring system"
        ),
        "Uranus": Planet(
            name: "Uranus",
            moonCount: 27,
            distanceFromSun: 19.22,
            diameter: 51118,
            description: "An ice giant that rotates on its side"
        ),
        "Neptune": Planet(
            name: "Neptune",
            moonCount: 16,
            distanceFromSun: 30.05,
            diameter: 49528,
            description: "The windiest planet in our solar system"
        )
    ]
    
    // MARK: - Public Methods
    func getPlanet(named name: String) -> Planet? {
        return planets[name]
    }
    
    func getAllPlanets() -> [Planet] {
        return Array(planets.values).sorted { $0.distanceFromSun < $1.distanceFromSun }
    }
    
    func getPlanetMoonCount(for planetName: String) -> Int {
        return planets[planetName]?.moonCount ?? 0
    }
}
