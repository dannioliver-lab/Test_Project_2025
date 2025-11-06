import UIKit

/// Main view controller that demonstrates pull-to-refresh functionality
class MainListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var listItems: [ListItem] = []
    private var refreshControl: UIRefreshControl!
    private var isLoading = false
    private let dataService = DataService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupRefreshControl()
        loadInitialData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Pull to Refresh Demo"
        view.backgroundColor = UIColor.systemBackground
        
        // Configure navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        // Configure table view appearance
        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.separator
        
        // Register cell (already done in storyboard, but good practice)
        // tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: ListItemTableViewCell.reuseIdentifier)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        // Customize refresh control appearance
        refreshControl.tintColor = UIColor.systemBlue
        refreshControl.attributedTitle = NSAttributedString(
            string: "Pull to refresh",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        
        // Add refresh control to table view
        tableView.refreshControl = refreshControl
        
        // Enable pull-to-refresh
        tableView.alwaysBounceVertical = true
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        guard !isLoading else { return }
        
        isLoading = true
        showLoadingState()
        
        dataService.fetchInitialData { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            self.hideLoadingState()
            
            switch result {
            case .success(let items):
                self.listItems = items
                self.tableView.reloadData()
                self.animateTableViewAppearance()
                
            case .failure(let error):
                self.handleError(error, isInitialLoad: true)
            }
        }
    }
    
    @objc private func handleRefresh() {
        guard !isLoading else {
            refreshControl.endRefreshing()
            return
        }
        
        isLoading = true
        
        // Update refresh control title
        refreshControl.attributedTitle = NSAttributedString(
            string: "Refreshing...",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        
        dataService.refreshData { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            // Reset refresh control title
            self.refreshControl.attributedTitle = NSAttributedString(
                string: "Pull to refresh",
                attributes: [
                    .foregroundColor: UIColor.secondaryLabel,
                    .font: UIFont.systemFont(ofSize: 14)
                ]
            )
            
            // End refreshing animation
            self.refreshControl.endRefreshing()
            
            switch result {
            case .success(let newItems):
                self.handleSuccessfulRefresh(with: newItems)
                
            case .failure(let error):
                self.handleError(error, isInitialLoad: false)
            }
        }
    }
    
    private func handleSuccessfulRefresh(with newItems: [ListItem]) {
        let oldItems = listItems
        listItems = newItems
        
        // Animate the refresh
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        } completion: { _ in
            // Briefly highlight new content
            self.highlightNewContent()
        }
        
        // Show success feedback
        showRefreshSuccessMessage()
    }
    
    // MARK: - UI State Management
    private func showLoadingState() {
        // Could add a loading spinner here for initial load
        tableView.isUserInteractionEnabled = false
    }
    
    private func hideLoadingState() {
        tableView.isUserInteractionEnabled = true
    }
    
    private func animateTableViewAppearance() {
        tableView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
    
    private func highlightNewContent() {
        // Briefly highlight the first few cells to show new content
        let visibleCells = tableView.visibleCells.prefix(3)
        for (index, cell) in visibleCells.enumerated() {
            if let listCell = cell as? ListItemTableViewCell {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                    listCell.highlightForRefresh()
                }
            }
        }
    }
    
    private func showRefreshSuccessMessage() {
        // Create a subtle success indicator
        let label = UILabel()
        label.text = "✓ Updated"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.systemGreen
        label.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.alpha = 0
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Animate in and out
        UIView.animate(withDuration: 0.3, animations: {
            label.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                label.alpha = 0
            }) { _ in
                label.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: NetworkError, isInitialLoad: Bool) {
        if isInitialLoad {
            showErrorState(error)
        } else {
            showErrorAlert(error)
        }
    }
    
    private func showErrorState(_ error: NetworkError) {
        // Show error state in the table view
        listItems = [
            ListItem(title: "⚠️ \(error.title)", subtitle: error.localizedDescription),
            ListItem(title: "Tap to retry", subtitle: "Pull down to refresh or tap here to try again")
        ]
        tableView.reloadData()
    }
    
    private func showErrorAlert(_ error: NetworkError) {
        let alert = UIAlertController(
            title: error.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
            self.handleRefresh()
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListItemTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ListItemTableViewCell else {
            return UITableViewCell()
        }
        
        let item = listItems[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = listItems[indexPath.row]
        
        // Handle special error state taps
        if item.title.contains("Tap to retry") {
            loadInitialData()
            return
        }
        
        // Show item details
        showItemDetails(item)
    }
    
    private func showItemDetails(_ item: ListItem) {
        let alert = UIAlertController(
            title: item.title,
            message: item.subtitle,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
