import UIKit
import SwiftUI

class FocusViewController: UIViewController {

    private var hostingController: UIHostingController<AnyView>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Grab the managed object context from the AppDelegate
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Initialize your SwiftUI view with the managed object context
        let focusSwiftUIView = FocusSwiftUIView().environment(\.managedObjectContext, context)
        
        hostingController = UIHostingController(rootView: AnyView(focusSwiftUIView))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Set constraint for the hosting controller
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
