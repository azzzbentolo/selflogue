import UIKit
import SwiftUI
import CoreData


/// `HabitViewController` is a UIKit View Controller that hosts a SwiftUI `HabitView`.
/// It serves as the entry point of the application and manages the lifecycle of the View Controller.
///
/// The `HabitViewController` demonstrates the interoperability between SwiftUI and UIKit frameworks.
/// It creates an instance of the `UIHostingController` to embed the SwiftUI `HabitView` within the UIKit-based app.
///
/// This View Controller follows the principles of Object-Oriented Programming (OOP) by encapsulating related properties and behavior.
/// It manages the presentation of the SwiftUI view hierarchy and handles any necessary UIKit-specific interactions.
///
/// The `HabitViewController` establishes a connection between the UIKit-based app and the SwiftUI-based `HabitView`, allowing for a seamless integration of the SwiftUI View into the UIKit app's navigation and lifecycle.


// This class represents the view controller of the Habit.
class HabitViewController: UIViewController {
    
    
    // The hosting controller to manage SwiftUI views.
    private var hostingController: UIHostingController<AnyView>!
    
    
    // This function is called when the view controller’s view is loaded into memory.
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Fetching the context from the AppDelegate.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Initializing the content view with the HabitView and passing in the context.
        let contentView = AnyView(HabitView().environment(\.managedObjectContext, context))
        
        // Creating a UIHostingController with the content view.
        hostingController = UIHostingController(rootView: contentView)
        
        // Adding the hosting controller as a child.
        addChild(hostingController)
        
        // Adding the hosting controller's view to this view controller's view.
        view.addSubview(hostingController.view)
        
        // Setting up constraints for the hosting controller's view.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Informing the hosting controller that it has been moved to this parent view controller.
        hostingController.didMove(toParent: self)
    }
}
