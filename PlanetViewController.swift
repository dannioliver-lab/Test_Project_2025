import UIKit

class PlanetViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let planetaryDataManager = PlanetaryDataManager.shared
    private var planets: [Planet] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPlanetaryData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Solar System"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlanetTableViewCell.self, forCellReuseIdentifier: "PlanetCell")
    }
    
    private func loadPlanetaryData() {
        planets = planetaryDataManager.getAllPlanets()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PlanetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath) as! PlanetTableViewCell
        let planet = planets[indexPath.row]
        cell.configure(with: planet)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlanetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let planet = planets[indexPath.row]
        showPlanetDetails(for: planet)
    }
    
    private func showPlanetDetails(for planet: Planet) {
        let alert = UIAlertController(
            title: planet.name,
            message: """
            Moons: \(planet.moonCount)
            Distance from Sun: \(planet.distanceFromSun) AU
            Diameter: \(String(format: "%.0f", planet.diameter)) km
            
            \(planet.description)
            """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
