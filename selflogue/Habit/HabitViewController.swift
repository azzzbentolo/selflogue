import UIKit
import SwiftUI
import CoreData

class HabitViewController: UIViewController {

    // Create property for UIHostingController
    private var hostingController: UIHostingController<AnyView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let contentView = AnyView(HabitView().environment(\.managedObjectContext, context))
        
        // Assign hostingController
        hostingController = UIHostingController(rootView: contentView)
        
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
