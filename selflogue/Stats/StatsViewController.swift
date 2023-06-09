import UIKit
import SwiftUI


/// `StatsViewController` is a UIKit view controller that integrates the `StatsView`into a UIKit-based application.
///
/// It follows the MVC (Model-View-Controller) architecture, where the view controller acts as the controller in the architecture.
/// It manages the setup of the view hierarchy and the lifecycle of the SwiftUI-based `StatsView`.
/// The view controller interacts with the underlying data model (`FocusTimeManager`) to fetch focus time data for the week and month periods.
///
/// `StatsViewController` inherits from `UIViewController`, a UIKit base class, to utilize its functionality and lifecycle management, showing good use of OOP


// StatsViewController is the UIViewController that contains and manages the StatsView.
class StatsViewController: UIViewController {
    
    
    // Hosting controller for the SwiftUI StatsView.
    private var hostingController: UIHostingController<StatsView>!
    
    
    // Lifecycle method, called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize the hosting controller with a StatsView as the root view.
        hostingController = UIHostingController(rootView: StatsView())
        
        // Add the hosting controller as a child.
        addChild(hostingController)
        
        // Add the hosting controller's view to the view hierarchy.
        view.addSubview(hostingController.view)
        
        // Set constraints for the hosting controller's view to match the parent view.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Notify the hosting controller that it has been moved to the parent controller.
        hostingController.didMove(toParent: self)
    }
}
