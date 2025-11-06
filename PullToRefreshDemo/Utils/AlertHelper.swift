import UIKit

/// Utility class for creating and displaying alerts
class AlertHelper {
    
    /// Shows a simple alert with title and message
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - viewController: View controller to present the alert from
    ///   - completion: Optional completion handler
    static func showAlert(
        title: String,
        message: String,
        from viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        
        viewController.present(alert, animated: true)
    }
    
    /// Shows an error alert with retry option
    /// - Parameters:
    ///   - error: The network error to display
    ///   - viewController: View controller to present the alert from
    ///   - retryAction: Action to perform when retry is tapped
    ///   - cancelAction: Optional action to perform when cancel is tapped
    static func showErrorAlert(
        error: NetworkError,
        from viewController: UIViewController,
        retryAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: error.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
            retryAction()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelAction?()
        })
        
        viewController.present(alert, animated: true)
    }
    
    /// Shows a confirmation alert with custom actions
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - confirmTitle: Title for confirm button
    ///   - cancelTitle: Title for cancel button
    ///   - viewController: View controller to present the alert from
    ///   - confirmAction: Action to perform when confirm is tapped
    ///   - cancelAction: Optional action to perform when cancel is tapped
    static func showConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        from viewController: UIViewController,
        confirmAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmAction()
        })
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        })
        
        viewController.present(alert, animated: true)
    }
    
    /// Shows a success message as a temporary toast-like alert
    /// - Parameters:
    ///   - message: Success message to display
    ///   - viewController: View controller to present the alert from
    ///   - duration: How long to show the alert (default: 1.5 seconds)
    static func showSuccessToast(
        message: String,
        from viewController: UIViewController,
        duration: TimeInterval = 1.5
    ) {
        let alert = UIAlertController(title: "✓ Success", message: message, preferredStyle: .alert)
        
        viewController.present(alert, animated: true)
        
        // Auto-dismiss after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    /// Shows an action sheet with multiple options
    /// - Parameters:
    ///   - title: Action sheet title
    ///   - message: Action sheet message
    ///   - actions: Array of action titles and handlers
    ///   - viewController: View controller to present the action sheet from
    ///   - sourceView: Source view for iPad presentation (optional)
    static func showActionSheet(
        title: String?,
        message: String?,
        actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)],
        from viewController: UIViewController,
        sourceView: UIView? = nil
    ) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            actionSheet.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler()
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Configure for iPad
        if let popover = actionSheet.popoverPresentationController {
            if let sourceView = sourceView {
                popover.sourceView = sourceView
                popover.sourceRect = sourceView.bounds
            } else {
                popover.sourceView = viewController.view
                popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
        }
        
        viewController.present(actionSheet, animated: true)
    }
}

// MARK: - Toast-like Notifications
extension AlertHelper {
    
    /// Shows a custom toast notification at the top of the screen
    /// - Parameters:
    ///   - message: Message to display
    ///   - type: Type of notification (success, error, info)
    ///   - viewController: View controller to show the toast in
    ///   - duration: How long to show the toast
    static func showToast(
        message: String,
        type: ToastType = .info,
        in viewController: UIViewController,
        duration: TimeInterval = 2.0
    ) {
        let toastView = createToastView(message: message, type: type)
        
        viewController.view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toastView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            toastView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            toastView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
        
        // Animate in
        toastView.alpha = 0
        toastView.transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            toastView.alpha = 1
            toastView.transform = .identity
        } completion: { _ in
            // Animate out after duration
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseIn) {
                toastView.alpha = 0
                toastView.transform = CGAffineTransform(translationX: 0, y: -50)
            } completion: { _ in
                toastView.removeFromSuperview()
            }
        }
    }
    
    private static func createToastView(message: String, type: ToastType) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = type.backgroundColor
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = type.textColor
        label.numberOfLines = 0
        label.textAlignment = .center
        
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
}

// MARK: - Toast Types
enum ToastType {
    case success
    case error
    case info
    case warning
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor.systemGreen.withAlphaComponent(0.9)
        case .error:
            return UIColor.systemRed.withAlphaComponent(0.9)
        case .info:
            return UIColor.systemBlue.withAlphaComponent(0.9)
        case .warning:
            return UIColor.systemOrange.withAlphaComponent(0.9)
        }
    }
    
    var textColor: UIColor {
        return UIColor.white
    }
}
