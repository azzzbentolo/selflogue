//
//  FocusViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 27/4/2023.
//

import UIKit
import SwiftUI

class FocusViewController: UIViewController {

    
    private var hostingController: UIHostingController<FocusSwiftUIView>!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hostingController = UIHostingController(rootView: FocusSwiftUIView())
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


