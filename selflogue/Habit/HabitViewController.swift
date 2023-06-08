import UIKit
import SwiftUI
import CoreData

class HabitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let contentView = HabitView().environment(\.managedObjectContext, context)
        
        let hostVC = UIHostingController(rootView: contentView)
        addChild(hostVC)
        view.addSubview(hostVC.view)
        hostVC.view.frame = view.bounds
        hostVC.didMove(toParent: self)
    }
}
