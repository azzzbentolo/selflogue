import UIKit
import SwiftUI


/// `StatsViewController` is a UIKit view controller that integrates the `StatsView`into a UIKit-based application.
///
/// It follows the MVC (Model-View-Controller) architecture, where the view controller acts as the controller in the architecture.
/// It manages the setup of the view hierarchy and the lifecycle of the SwiftUI-based `StatsView`.
/// The view controller interacts with the underlying data model (`FocusTimeManager`) to fetch focus time data for the week and month periods.
///
/// `StatsViewController` inherits from `UIViewController`, a UIKit base class, to utilize its functionality and lifecycle management, showing good use of OOP


class StatsViewController: UIViewController {
    
    
    private var hostingController: UIHostingController<StatsView>!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hostingController = UIHostingController(rootView: StatsView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
