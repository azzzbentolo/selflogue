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



class HabitViewController: UIViewController {
    
    
    private var hostingController: UIHostingController<AnyView>!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let contentView = AnyView(HabitView().environment(\.managedObjectContext, context))
        
        hostingController = UIHostingController(rootView: contentView)
        
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
