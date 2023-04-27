//
//  StatsViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 27/4/2023.
//


import UIKit
import SwiftUI

class StatsViewController: UIViewController {
    
    
    private var hostingController: UIHostingController<TimerSwiftUIView>!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        hostingController = UIHostingController(rootView: TimerSwiftUIView())
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


//class StatsViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
