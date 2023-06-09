//
//  MainViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 26/4/2023.
//

import UIKit
import SwiftUI
import FSCalendar


/// MainViewController is a UIViewController subclass that serves as the main view controller of the application.
/// It manages the main user interface, including the quote label, calendar view, and add logue button.
///
/// MainViewController follows the MVC (Model-View-Controller) architecture.
/// It acts as the controller, responsible for handling user interactions and managing the data flow between the model and the view.
///
/// The view hierarchy of MainViewController consists of several UI elements, including a UILabel, FSCalendar, and UIButton.
/// It sets up the calendar, quote, and button appearances, and handles calendar delegate methods.
///
/// It communicates with the Quote class to fetch a random quote from the quotable API and display it on the quote label.
/// It also interacts with ImagesManager to retrieve images for a selected date and present the image list view.
/// Additionally, it uses UserDefaults to load and display the username in the navigation title.
///
/// Overall, MainViewController serves as the entry point of the application and manages the main user interface and interactions.


class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var addLogueButton: UIButton!
    
    
    let THEME_COL: UIColor = UIColor(red: 84, green: 65, blue: 177)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCalendar()
        setUpLineView()
        setUpAddButton()
        setUpProfileButton()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.quote.text = ""
        fetchQuote()
        loadUsername()
        
    }
    
    
    func fetchQuote() {
        
        Task {
            let quoteInstance = Quote()
            await quoteInstance.requestQuote(maxLength: 100)
            
            await MainActor.run {
                let quoteText = "\(quoteInstance.quote!)\n"
                let authorText = "--\(quoteInstance.quoteAuthor!)"
                
                let quoteAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: quote.font.pointSize + 2)]
                let authorAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: quote.font.pointSize)]
                
                let attributedQuote = NSMutableAttributedString(string: quoteText, attributes: quoteAttributes)
                let attributedAuthor = NSAttributedString(string: authorText, attributes: authorAttributes)
                
                attributedQuote.append(attributedAuthor)
                self.quote.attributedText = attributedQuote
            }
        }
        
    }
    
    
    func setUpAddButton() {
        
        addLogueButton.tintColor = .white
        addLogueButton.backgroundColor = THEME_COL
        addLogueButton.layer.cornerRadius = 22.5
        
    }
    
    
    func setUpProfileButton() {
        
        let imageSize: CGFloat = 30
        
        let profileImageView = UIImageView(image: UIImage(systemName: "gear"))
        profileImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.tintColor = .black
        
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 100, y: 100, width: imageSize, height: imageSize)
        profileButton.addSubview(profileImageView)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        let containerFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize + 5)
        let containerView = UIView(frame: containerFrame)
        containerView.backgroundColor = .clear
        containerView.addSubview(profileButton)
        
        profileButton.center = CGPoint(x: containerView.center.x, y: containerView.center.y + 15)
        
        let barButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let images = imagesForDate(date)
        if !images.isEmpty {
            presentImageListView(for: date)
        }
        
    }

    
    func setUpCalendar() {
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.locale = Locale(identifier: "en_US")
        calendar.headerHeight = 60
        calendar.weekdayHeight = 40
        
        let appearance = calendar.appearance
        appearance.headerTitleColor = UIColor(red: 130, green: 130, blue: 130)
        appearance.headerTitleFont = UIFont(name: "Lato-Bold", size: 20)
        
        appearance.weekdayTextColor = UIColor.black
        appearance.weekdayFont = UIFont(name: "Lato-Regular", size: 14)
        appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        appearance.borderRadius = .zero
        appearance.headerMinimumDissolvedAlpha = 0
        
        appearance.titleSelectionColor = UIColor.black
        
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
        
        if todayDateString == currentDateString {
            return UIColor(red: 84, green: 65, blue: 177, alpha: 0.85)
        } else {
            return nil
        }
    }
    
    
    func setUpLineView() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: 158, width: 500, height: 1.5))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 130, green: 130, blue: 130).cgColor
        self.view.addSubview(lineView)
        
    }
    
    
    func presentImageListView(for date: Date) {
        let vc = UIHostingController(rootView: ImagesListView(selectedDate: date))
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private func imagesForDate(_ date: Date) -> [(String, (UIImage, String, Date))] {
        
        return ImagesManager.shared.imageFiles.filter { $0.value.2.dateOnly() == date }
        
    }
    
    
    @objc func profileButtonTapped() {
        print("Button tapped")
        let settingsView = SettingsView()

        let vc = UIHostingController(rootView: settingsView)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    class TouchThroughView: UIView {
        var button: UIButton?
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            if let button = self.button, button.frame.contains(point) {
                return button
            }
            return super.hitTest(point, with: event)
        }
    }
    
    
    func loadUsername() {
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: "username") {
            self.navigationItem.title = "Welcome! \(username)"
        }
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
