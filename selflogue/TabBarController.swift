//
//  TabBarController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 26/4/2023.
//

import UIKit


class TabBarController: UITabBarController {
    
    
    var isInitialTabSet = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        if !isInitialTabSet {
            selectedIndex = 2
            isInitialTabSet = true
        }
        
        self.tabBar.tintColor = UIColor(red: 84, green: 65, blue: 177, alpha: 0.85)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
