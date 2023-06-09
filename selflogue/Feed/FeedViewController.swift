
/// `FeedViewController` is a UIKit view controller that embeds the SwiftUI `ImagesScrollView` view.
/// As a UIViewController, it fits into the MVC architecture as the Controller, bridging between the Model (`ImagesManager` and the images it manages) and the View (`ImagesScrollView`).
///
/// In the MVC pattern, `FeedViewController` responds to lifecycle events and updates the Model accordingly. In `viewWillAppear`, it triggers a load of image files from `ImagesManager`.
///
/// `FeedViewController`'s primary responsibility is adding `ImagesScrollView` to its view hierarchy and setting up constraints for it.
/// This follows the principles of OOP by encapsulating the functionality related to integrating a SwiftUI view within a UIKit context.
///


import UIKit
import SwiftUI


// FeedViewController is a UIViewController that displays an ImagesScrollView
class FeedViewController: UIViewController {
    
    
    // Called when the view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        addImagesScrollView()
    }
     
    
    // Called when the view is about to be added to a view hierarchy
    // Here it reloads the image files
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImagesManager.shared.loadImageFiles()
    }
    
    
    // Function to add an ImagesScrollView to the UIViewController
    func addImagesScrollView() {
        
        let imagesScrollView = ImagesScrollView()
        let hostingController = UIHostingController(rootView: imagesScrollView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
            
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
