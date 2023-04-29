//
//  FocusViewController.swift
//  selflogue
//
//  Created by Chew Jun Pin on 27/4/2023.
//

import UIKit

class FocusViewController: UIViewController {

    
    var timer: Timer?
    var timeRemaining: Int = 1500 // 25 minutes in seconds
    let breakDuration: Int = 300 // 5 minutes in seconds

    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerLabel()
    }
    
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        if timer == nil {
            startTimer()
            startStopButton.setTitle("Stop", for: .normal)
        } else {
            stopTimer()
            startStopButton.setTitle("Start", for: .normal)
        }
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        stopTimer()
        timeRemaining = 1500
        updateTimerLabel()
        startStopButton.setTitle("Start", for: .normal)
    }

    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateTimerLabel()
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.timeRemaining = self.breakDuration
                self.updateTimerLabel()
            }
        }
    }
    
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    func updateTimerLabel() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
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


