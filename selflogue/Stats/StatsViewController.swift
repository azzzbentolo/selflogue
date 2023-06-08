import UIKit
import SwiftUI

class StatsViewController: UIViewController {
    
    private var hostingController: UIHostingController<StatsView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostingController = UIHostingController(rootView: StatsView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Set constraints for the hosting controller
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
