import UIKit
import SwiftUI


/// `FocusViewController` is a UIViewController subclass that hosts the SwiftUI-based `FocusSwiftUIView`.
/// It acts as the controller in the MVC (Model-View-Controller) architecture.
///
/// `FocusViewController` manages the view hierarchy and coordinates between the model (`FocusTimeManager`) and the view (`FocusSwiftUIView`).
/// It initializes the Core Data context and passes it to `FocusTimeManager` to enable focus time management.
///
/// The view controller sets up the `FocusSwiftUIView` as a child view controller and adds its view to the view hierarchy.
/// It handles the lifecycle events and ensures the proper integration of the SwiftUI view within the UIKit-based app.
///
/// By following the MVC architecture, `FocusViewController` separates the responsibilities of managing the view hierarchy and interacting with the model, resulting in a more modular and maintainable codebase.
///
///`FocusViewController` inherits from `UIViewController`, providing the basic infrastructure for managing the view hierarchy and handling lifecycle events, showing good use of OOP.


class FocusViewController: UIViewController {

    
    private var hostingController: UIHostingController<AnyView>!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let focusSwiftUIView = FocusSwiftUIView().environment(\.managedObjectContext, context)
        
        hostingController = UIHostingController(rootView: AnyView(focusSwiftUIView))
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
