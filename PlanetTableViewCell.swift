import UIKit

class PlanetTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let planetNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(planetNameLabel)
        contentView.addSubview(moonCountLabel)
        contentView.addSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            // Planet name label
            planetNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            planetNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            planetNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Moon count label
            moonCountLabel.topAnchor.constraint(equalTo: planetNameLabel.bottomAnchor, constant: 4),
            moonCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moonCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Distance label
            distanceLabel.topAnchor.constraint(equalTo: moonCountLabel.bottomAnchor, constant: 2),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with planet: Planet) {
        planetNameLabel.text = planet.name
        
        // Format moon count with proper grammar
        let moonText: String
        switch planet.moonCount {
        case 0:
            moonText = "No moons"
        case 1:
            moonText = "1 moon"
        default:
            moonText = "\(planet.moonCount) moons"
        }
        moonCountLabel.text = moonText
        
        distanceLabel.text = "\(planet.distanceFromSun) AU from Sun"
    }
}
