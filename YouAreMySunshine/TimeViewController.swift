//
//  TimeViewController.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var bgView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
            tap.delegate = self
            bgView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var durationTextField: UITextField! {
        didSet {
            let datePickerView : UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = .countDownTimer
            durationTextField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.handleDatePicker), for: UIControlEvents.valueChanged)
        }
    }
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maxDurationLabel: UILabel!
    
    var duration: Date!
    
    // Passed in
    var selectedIndex: IndexPath!
    var selectedAppliance: Appliance!
    var selectedUpperBound: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set max for time picker
        
        guard let appliance = selectedAppliance else { print("Failed to retrieve appliance.");return }
        titleLabel.text = "How long will you use your \(appliance.name)?"
        
        guard let maxDuration = selectedUpperBound else { print("Failed to retrieve upper bound.");return }
        let hours = floor(maxDuration / 3600)
        let minutes = floor((maxDuration).truncatingRemainder(dividingBy: 3600)) / 60
        maxDurationLabel.text = "Max duration: \(Int(hours)):\(Int(minutes))"
        
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func doneButtonPress(_ sender: Any) {
        guard let dur = duration else {
            let alert = UIAlertController(title: "Error", message: "Please Select a duration!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return }
        
        guard let index = selectedIndex else { print("Somehow the index did not get passed... this is a problem");return }
        
        ShareData.sharedInstance.duration = dur
        ShareData.sharedInstance.selectedIndex = index
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addAppliance"), object: nil)
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    // MARK: - TextField Picker
    
    func handleDatePicker(sender: UIDatePicker) {
        if (sender.countDownDuration <= selectedUpperBound) {
            duration = sender.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            durationTextField.text = dateFormatter.string(from: sender.date)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please select a shorter time duration! You dont have enough power to use that item!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    func dismissView() {
        ShareData.sharedInstance.selectedIndex = selectedIndex
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "deselectView"), object: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
