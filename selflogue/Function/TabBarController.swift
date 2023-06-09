import UIKit

// Custom UITabBarController subclass for managing the tab bar interface.
class TabBarController: UITabBarController {
    
    // Boolean flag to track whether the initial tab is set.
    var isInitialTabSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Set the initial tab to index 2 if it has not been set before.
        if !isInitialTabSet {
            selectedIndex = 2
            isInitialTabSet = true
        }
        
        // Customize the tab bar tint color.
        self.tabBar.tintColor = UIColor(red: 84, green: 65, blue: 177, alpha: 0.85)
    }
}
