import UIKit

/// Custom loading view with spinner and optional message
class LoadingView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let backgroundView = UIView()
    
    // MARK: - Properties
    var message: String? {
        didSet {
            updateMessage()
        }
    }
    
    var isAnimating: Bool {
        return activityIndicator.isAnimating
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    convenience init(message: String? = nil) {
        self.init(frame: .zero)
        self.message = message
        updateMessage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupActivityIndicator()
        setupMessageLabel()
        setupConstraints()
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundView.alpha = 0
        addSubview(backgroundView)
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.1
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        addSubview(containerView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.color = UIColor.systemBlue
        activityIndicator.hidesWhenStopped = true
        containerView.addSubview(activityIndicator)
    }
    
    private func setupMessageLabel() {
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = UIColor.label
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.alpha = 0
        containerView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Container view
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            
            // Message label
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Public Methods
    /// Starts the loading animation
    /// - Parameter animated: Whether to animate the appearance
    func startAnimating(animated: Bool = true) {
        activityIndicator.startAnimating()
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.backgroundView.alpha = 1
                self.containerView.alpha = 1
                self.containerView.transform = .identity
            }
        } else {
            backgroundView.alpha = 1
            containerView.alpha = 1
            containerView.transform = .identity
        }
    }
    
    /// Stops the loading animation
    /// - Parameter animated: Whether to animate the disappearance
    /// - Parameter completion: Optional completion handler
    func stopAnimating(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self.backgroundView.alpha = 0
                self.containerView.alpha = 0
                self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { _ in
                self.activityIndicator.stopAnimating()
                completion?()
            }
        } else {
            backgroundView.alpha = 0
            containerView.alpha = 0
            containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            activityIndicator.stopAnimating()
            completion?()
        }
    }
    
    /// Updates the loading message
    private func updateMessage() {
        messageLabel.text = message
        
        if message != nil && !message!.isEmpty {
            UIView.animate(withDuration: 0.2) {
                self.messageLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.messageLabel.alpha = 0
            }
        }
    }
    
    /// Shows the loading view in a parent view
    /// - Parameters:
    ///   - parentView: The view to add the loading view to
    ///   - animated: Whether to animate the appearance
    func show(in parentView: UIView, animated: Bool = true) {
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor),
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        startAnimating(animated: animated)
    }
    
    /// Hides and removes the loading view from its parent
    /// - Parameters:
    ///   - animated: Whether to animate the disappearance
    ///   - completion: Optional completion handler
    func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        stopAnimating(animated: animated) {
            self.removeFromSuperview()
            completion?()
        }
    }
}

// MARK: - Convenience Methods
extension LoadingView {
    
    /// Creates and shows a loading view with a message
    /// - Parameters:
    ///   - message: Loading message to display
    ///   - parentView: View to show the loading view in
    ///   - animated: Whether to animate the appearance
    /// - Returns: The created loading view
    @discardableResult
    static func show(
        message: String? = "Loading...",
        in parentView: UIView,
        animated: Bool = true
    ) -> LoadingView {
        let loadingView = LoadingView(message: message)
        loadingView.show(in: parentView, animated: animated)
        return loadingView
    }
    
    /// Hides all loading views in a parent view
    /// - Parameters:
    ///   - parentView: View to remove loading views from
    ///   - animated: Whether to animate the disappearance
    ///   - completion: Optional completion handler
    static func hideAll(
        in parentView: UIView,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let loadingViews = parentView.subviews.compactMap { $0 as? LoadingView }
        
        guard !loadingViews.isEmpty else {
            completion?()
            return
        }
        
        let group = DispatchGroup()
        
        for loadingView in loadingViews {
            group.enter()
            loadingView.hide(animated: animated) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
}
