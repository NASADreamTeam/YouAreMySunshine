//
//  DetailViewController.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/30/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var applianceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var wattageConsumedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var applianceIconImageView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var lightBulbImageView: UIImageView!
    @IBOutlet weak var lightBulbNumberLabel: UILabel!
    @IBOutlet weak var totalWattsUsedLabel: UILabel!
    @IBOutlet weak var solarPanelNumberLabel: UILabel!
    @IBOutlet weak var totalEnergyLabel: UILabel!
    
    var counter:Double = 0 {
        didSet {
            let fractionalProgress = Float(counter)// / 100.0
            print("Fractional: \(fractionalProgress)")
            let animated = counter != 0
            
            progressView.setProgress(fractionalProgress, animated: animated)
            //progressLabel.text = ("\(counter)%")
        }
    }

    
    var appliance: Appliance!
    
    var totalWatNumber: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        applianceIconImageView.image = appliance.image.maskWithColor(color: UIColor.black)
        applianceLabel.text = "\(appliance.name)"
        durationLabel.text = "Used for: \(dateFormatter.string(from: appliance.timeUsed))"
        wattageConsumedLabel.text = "Baseline Wattage: \(Int(appliance.energy)) W"
        totalEnergyLabel.text = "Total Energy: \(Int(appliance.energyUsage)) Wh"
        lightBulbNumberLabel.text = "\(Int(floor(appliance.energyUsage / 14)))" // CFL lightbulb
        solarPanelNumberLabel.text = "\(Int(ceil(appliance.energyUsage/250)))"
        totalWattsUsedLabel.text = "hours to generate \(Int(appliance.energyUsage)) Wh"
        
        guard let max = totalWatNumber else { return }
        let min = appliance.energyUsage
        counter = (min / max)
        
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
