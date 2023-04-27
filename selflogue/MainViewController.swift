//
//  MainViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 26/4/2023.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    
    @IBOutlet weak var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCalendar()
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print("\(string)")
        
    }
    
    
    func setUpCalendar() {
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.locale = Locale(identifier: "en_US")
        
        // Customize the appearance of the month header
        let appearance = calendar.appearance
        let themeCol = UIColor(red: 130, green: 130, blue: 130)
        appearance.headerTitleColor = themeCol
        appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // Customize the appearance of the weekday text
        appearance.weekdayTextColor = UIColor.black
        appearance.weekdayFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        appearance.borderRadius = .zero
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor(red: 84, green: 65, blue: 177)
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
