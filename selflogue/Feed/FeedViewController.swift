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
        let hostVC = UIHostingController(rootView: imagesScrollView)
        addChild(hostVC)
        hostVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostVC.view)
            
        NSLayoutConstraint.activate([
            hostVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostVC.didMove(toParent: self)
    }
}
