import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var contentItems: [ContentItem] = []
    private let contentService = ContentService.shared
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .systemBlue
        return refreshControl
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Pull down to refresh content"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialContent()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Home"
        view.backgroundColor = .systemBackground
        
        // Setup navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Add table view
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        // Add refresh control to table view
        tableView.refreshControl = refreshControl
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadInitialContent() {
        Task {
            let items = await contentService.loadInitialContent()
            await MainActor.run {
                self.contentItems = items
                self.updateUI()
            }
        }
    }
    
    @objc private func handleRefresh() {
        Task {
            do {
                let refreshedItems = try await contentService.refreshContent()
                await MainActor.run {
                    self.contentItems = refreshedItems
                    self.updateUI()
                    self.refreshControl.endRefreshing()
                    
                    // Show success feedback
                    self.showRefreshSuccessMessage()
                }
            } catch {
                await MainActor.run {
                    self.refreshControl.endRefreshing()
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
    
    private func updateUI() {
        emptyStateLabel.isHidden = !contentItems.isEmpty
        tableView.reloadData()
    }
    
    // MARK: - User Feedback
    private func showRefreshSuccessMessage() {
        // Create a subtle success indicator
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Optional: Show a brief success message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alert = UIAlertController(title: "✅ Refreshed", message: "Content updated successfully", preferredStyle: .alert)
            self.present(alert, animated: true)
            
            // Auto-dismiss after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.dismiss(animated: true)
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Refresh Failed",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
            self.handleRefresh()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        let item = contentItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = contentItems[indexPath.row]
        let alert = UIAlertController(
            title: item.title,
            message: item.subtitle,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
