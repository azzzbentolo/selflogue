import UIKit
import SwiftUI


class FeedViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImagesScrollView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImagesManager.shared.loadImageFiles()
    }
    
    
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
