//
//  MainViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 26/4/2023.
//

import UIKit
import SwiftUI
import FSCalendar


class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    let THEME_COL: UIColor = UIColor(red: 84, green: 65, blue: 177)

    
    @IBAction func refresh(_ sender: Any) {
        
        Task {
            let quoteInstance = Quote()
            await quoteInstance.requestQuote(maxLength: 150)
            await MainActor.run {
                self.quote.text = "\(quoteInstance.quote!)" + "\n" + "\(quoteInstance.quoteAuthor!)"
            }
        }
    }
        
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCalendar()
        setUpLineView()
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print("\(string)")
        
        let cell = calendar.cell(for: date, at: monthPosition)
        cell?.titleLabel.textColor = THEME_COL
    
    }

    
    func setUpCalendar() {
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.locale = Locale(identifier: "en_US")
        calendar.headerHeight = 60
        calendar.weekdayHeight = 40
        
        // Customize the appearance of the month header
        let appearance = calendar.appearance
        appearance.headerTitleColor = UIColor(red: 130, green: 130, blue: 130)
        appearance.headerTitleFont = UIFont(name: "Lato-Bold", size: 20)
        
        // Customize the appearance of the weekday text
        appearance.weekdayTextColor = UIColor.black
        appearance.weekdayFont = UIFont(name: "Lato-Regular", size: 14)
        appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        appearance.borderRadius = .zero
        appearance.headerMinimumDissolvedAlpha = 0
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return THEME_COL
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
            
        let todayDateString = formatter.string(from: today)
        let currentDateString = formatter.string(from: date)
            
        // If the date is today's date, return the custom fill color
        if todayDateString == currentDateString {
            return UIColor(red: 84, green: 65, blue: 177, alpha: 0.85)
        } else {
            return nil
        }
    }
    
    
    func setUpLineView() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: 175, width: 500, height: 1.5))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 130, green: 130, blue: 130).cgColor
        self.view.addSubview(lineView)
        
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
