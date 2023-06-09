
/// `MainViewController` is a UIViewController subclass that serves as the main view controller of the application.
/// It manages the main user interface, including the quote label, calendar view, and add logue button.
///
/// It follows the MVC (Model-View-Controller) architecture, where it acts as the controller in the architecture.
/// It is responsible for handling user interactions, managing the data flow between the model and the view, and setting up the calendar, quote, and button appearances.
///
/// `MainViewController` interacts with the `Quote` class to fetch a random quote from the quotable API.
/// It also communicates with `ImagesManager` to retrieve images for a selected date and present the image list view.
/// Additionally, it uses UserDefaults to load and display the username in the navigation title.
///
/// `MainViewController` uses the FSCalendar library as a dependency to provide the calendar functionality.
/// It conforms to FSCalendarDelegate and FSCalendarDataSource to provide and handle calendar data and events,
/// as well as FSCalendarDelegateAppearance to customize the calendar appearance.
///
/// This view controller serves as the entry point of the application and manages the main user interface and interactions.
///


import UIKit
import SwiftUI
import FSCalendar


class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    // UI elements for displaying the daily quote, calendar, and adding a new logue.
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var addLogueButton: UIButton!
    var profileImageView: UIImageView!
    
    
    // Constant color used for the theme of the application.
    let THEME_COL: UIColor = UIColor(red: 84, green: 65, blue: 177)
    
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCalendar() // Sets up the calendar view.
        setUpLineView() // Sets up the line view.
        setUpAddButton() // Sets up the add logue button.
        setUpProfileButton() // Sets up the profile button.
        updateAppearance() // Update view
        
    }
    
    
    // Called before the view is about to appear on the screen.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.quote.text = ""
        fetchQuote() // Fetches a new quote.
        loadUsername() // Loads the user's username.
        updateAppearance() // Update view
        
    }
    
    // Fetches a new quote from the quotable API.
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
    
    
    // Sets up the appearance of the add logue button.
    func setUpAddButton() {
        
        addLogueButton.tintColor = .white
        addLogueButton.backgroundColor = THEME_COL
        addLogueButton.layer.cornerRadius = 22.5
        
    }
    
    
    // Sets up the appearance and functionality of the profile button.
    func setUpProfileButton() {
        
        let imageSize: CGFloat = 30
        
        profileImageView = UIImageView(image: UIImage(systemName: "gear"))
        profileImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        profileImageView.contentMode = .scaleAspectFit
        
        // Update the profileImageView's tintColor based on the current interface style
        updateProfileImageViewTintColor()
        
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 80, y: 80, width: imageSize, height: imageSize)
        profileButton.addSubview(profileImageView)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        let containerFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        let containerView = UIView(frame: containerFrame)
        containerView.backgroundColor = .clear
        containerView.addSubview(profileButton)
        
        profileButton.center = CGPoint(x: containerView.center.x, y: containerView.center.y )
        
        let barButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    
    func updateProfileImageViewTintColor() {
        profileImageView.tintColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    
    // Handles the selection of a date on the calendar.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let images = imagesForDate(date)
        if !images.isEmpty {
            presentImageListView(for: date)
        }
        
    }
    
    
    // Sets up the appearance and functionality of the calendar.
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
        appearance.caseOptions = .weekdayUsesUpperCase
        appearance.borderRadius = .zero
        appearance.headerMinimumDissolvedAlpha = 0
        appearance.titleSelectionColor = UIColor.black
 
        
    }
    
    
    // Customizes the fill color of the selected date on the calendar.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    
    // Customizes the border color of the selected date on the calendar.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return THEME_COL
    }
    
    
    // Customizes the default fill color for dates on the calendar.
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
    
    
    // Sets up the line view.
    func setUpLineView() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: 158, width: 500, height: 1.5))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 130, green: 130, blue: 130).cgColor
        self.view.addSubview(lineView)
        
    }
    
    
    // Presents a view controller that displays a list of images for the selected date.
    func presentImageListView(for date: Date) {
        let vc = UIHostingController(rootView: ImagesListView(selectedDate: date))
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // Returns a list of image files for the selected date.
    private func imagesForDate(_ date: Date) -> [(String, (UIImage, String, Date))] {
        return ImagesManager.shared.imageFiles.filter { $0.value.2.dateOnly() == date }
    }
    
    
    // Handles the tapping of the profile button, presenting the settings view.
    @objc func profileButtonTapped() {
        let settingsView = SettingsView()
        
        let vc = UIHostingController(rootView: settingsView)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // A subclass of UIView that passes touch events through to a button.
    class TouchThroughView: UIView {
        var button: UIButton?
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            if let button = self.button, button.frame.contains(point) {
                return button
            }
            return super.hitTest(point, with: event)
        }
    }
    
    
    // Loads the user's username from UserDefaults and displays it in the navigation title.
    func loadUsername() {
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: "username") {
            self.navigationItem.title = "Welcome! \(username)"
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
            updateProfileImageViewTintColor()
        }
    }
    
    
    func updateAppearance() {
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        quote.textColor = isDarkMode ? .white : .black
        calendar.appearance.headerTitleColor = UIColor(red: 130, green: 130, blue: 130)
        calendar.appearance.weekdayTextColor = isDarkMode ? .white : .black
        calendar.appearance.titleDefaultColor = isDarkMode ? .white : .black
        calendar.appearance.titleWeekendColor = isDarkMode ? .white : .black
        calendar.appearance.titlePlaceholderColor = isDarkMode ? .white : .black
        calendar.appearance.eventDefaultColor = isDarkMode ? .white : .black
        calendar.appearance.selectionColor = THEME_COL
    }

}
