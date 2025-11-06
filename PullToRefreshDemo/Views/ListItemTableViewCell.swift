import UIKit

/// Custom table view cell for displaying list items
class ListItemTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Properties
    static let reuseIdentifier = "ListItemCell"
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure title label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 1
        
        // Configure subtitle label
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.numberOfLines = 2
        
        // Configure cell appearance
        selectionStyle = .default
        accessoryType = .none
        
        // Add subtle separator
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    // MARK: - Configuration
    /// Configures the cell with a ListItem
    /// - Parameter item: The ListItem to display
    func configure(with item: ListItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        // Add accessibility
        accessibilityLabel = "\(item.title), \(item.subtitle)"
        accessibilityTraits = .button
        accessibilityHint = "Double tap to select this item"
    }
    
    /// Configures the cell with custom title and subtitle
    /// - Parameters:
    ///   - title: The title text
    ///   - subtitle: The subtitle text
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        // Add accessibility
        accessibilityLabel = "\(title), \(subtitle)"
        accessibilityTraits = .button
        accessibilityHint = "Double tap to select this item"
    }
}

// MARK: - Animation Helpers
extension ListItemTableViewCell {
    
    /// Animates the cell appearance when it's added to the table
    func animateAppearance() {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
    }
    
    /// Highlights the cell briefly to indicate refresh
    func highlightForRefresh() {
        let originalBackgroundColor = backgroundColor
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = originalBackgroundColor
            }
        }
    }
}
