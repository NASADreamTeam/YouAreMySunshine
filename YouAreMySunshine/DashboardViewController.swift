//
//  ViewController.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit
import Charts
import CoreLocation

class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.alpha = 0.0
        }
    }
    @IBOutlet weak var highNumberLabel: UILabel!
    @IBOutlet weak var averageNumberLabel: UILabel!
    @IBOutlet weak var lowNumberLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView?.allowsMultipleSelection = true 
        }
    }
    @IBOutlet weak var barChart: HorizontalBarChartView! {
        didSet {
            barChart.xAxis.drawAxisLineEnabled = false
            barChart.xAxis.drawGridLinesEnabled = false
            barChart.xAxis.drawLabelsEnabled = false
            barChart.xAxis.drawLimitLinesBehindDataEnabled = false
            barChart.drawGridBackgroundEnabled = false
            barChart.rightAxis.drawGridLinesEnabled = false
            barChart.rightAxis.drawLimitLinesBehindDataEnabled = false
            //barChart.rightAxis.drawLabelsEnabled = false
            barChart.rightAxis.drawAxisLineEnabled = false
            barChart.rightAxis.drawZeroLineEnabled = false
            barChart.rightAxis.drawTopYLabelEntryEnabled = false
            
            barChart.leftAxis.drawGridLinesEnabled = false
            barChart.leftAxis.drawLimitLinesBehindDataEnabled = false
            barChart.leftAxis.drawLabelsEnabled = false
            barChart.leftAxis.drawAxisLineEnabled = false
            barChart.leftAxis.drawZeroLineEnabled = false
            barChart.leftAxis.drawTopYLabelEntryEnabled = false
            
            barChart.drawGridBackgroundEnabled = false
            barChart.doubleTapToZoomEnabled = false
            barChart.pinchZoomEnabled = false
            barChart.chartDescription?.text = ""
            
            barChart.delegate = self
        }
    }

    var activeApplianceList = [Appliance(name: "Free", energy: 100, energyUsage: 100.0, color: UIColor.green, image: UIImage(named: "tv")!)]
    
    let applianceList = [
        Appliance(name: "Clothes Dryer", energy: 2790, energyUsage: 0.0, color: UIColor(red: 80/255, green: 40/255, blue: 18/255, alpha: 1.0), image: UIImage(named: "dryer")!),
        Appliance(name: "Clothes Washer", energy: 255, energyUsage: 0.0, color: UIColor(red: 96/255, green: 54/255, blue: 24/255, alpha: 1.0), image: UIImage(named: "cwasher")!),
        Appliance(name: "Coffee Maker", energy: 1000, energyUsage: 0.0, color: UIColor(red: 133/255, green: 87/255, blue: 35/255, alpha: 1.0), image: UIImage(named: "coffee")!),
        Appliance(name: "Laptop", energy: 25, energyUsage: 0.0, color: UIColor(red: 137/255, green: 32/255, blue: 52/255, alpha: 1.0), image: UIImage(named: "laptop")!),
        Appliance(name: "Dishwasher", energy: 330, energyUsage: 0.0, color: UIColor(red: 122/255, green: 26/255, blue: 87/255, alpha: 1.0), image: UIImage(named: "dwasher")!),
        Appliance(name: "Microwave", energy: 1500, energyUsage: 0.0, color: UIColor(red: 111/255, green: 37/255, blue: 108/255, alpha: 1.0), image: UIImage(named: "microwave")!),
        Appliance(name: "Power Tool", energy: 13, energyUsage: 0.0, color: UIColor(red: 0/255, green: 52/255, blue: 77/255, alpha: 1.0), image: UIImage(named: "powertool")!),
        Appliance(name: "Fridge", energy: 225, energyUsage: 0.0, color: UIColor(red: 0/255, green: 48/255, blue: 102/255, alpha: 1.0), image: UIImage(named: "fridge")!),
        Appliance(name: "Space Heater", energy: 1320, energyUsage: 0.0, color: UIColor(red: 87/255, green: 82/255, blue: 126/255, alpha: 1.0), image: UIImage(named: "heater")!),
        Appliance(name: "TV", energy: 150, energyUsage: 0.0, color: UIColor(red: 0/255, green: 66/255, blue: 54/255, alpha: 1.0), image: UIImage(named: "tv")!),
        Appliance(name: "Toaster", energy: 1100, energyUsage: 0.0, color: UIColor(red: 64/255, green: 70/255, blue: 22/255, alpha: 1.0), image: UIImage(named: "toaster")!),
        Appliance(name: "Game Console", energy: 36, energyUsage: 0.0, color: UIColor(red: 159/255, green: 155/255, blue: 116/255, alpha: 1.0), image: UIImage(named: "game")!),
        Appliance(name: "Water Heater", energy: 4500, energyUsage: 0.0, color: UIColor(red: 102/255, green: 141/255, blue: 60/255, alpha: 1.0), image: UIImage(named: "wheater")!),
        Appliance(name: "Well Pump", energy: 725, energyUsage: 0.0, color: UIColor(red: 129/255, green: 108/255, blue: 91/255, alpha: 1.0), image: UIImage(named: "wpump")!),
        ]
    
    let locationManager = CLLocationManager()
    
    var selectedUpperBound: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        highNumberLabel.alpha = 0.0
        lowNumberLabel.alpha = 0.0
        averageNumberLabel.alpha = 0.0

        let energyValue = activeApplianceList.map( { $0.energy })
        updateGraph(activeAppliances: energyValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemAddition), name: NSNotification.Name(rawValue: "addItem"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDeselect), name: NSNotification.Name(rawValue: "cancelView"), object: nil)
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Graph
    
    func updateGraph(activeAppliances: Array<Double>) {
        let dataEntries = [BarChartDataEntry(x: 0.0, yValues: activeAppliances)]
        
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "")
        
        let colorValues = activeApplianceList.map( { $0.color })
        barChartDataSet.colors = colorValues//ChartColorTemplates.material()
        
        let labelValues = activeApplianceList.map( { $0.name })
        barChartDataSet.stackLabels = labelValues
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 12.0))
        barChart.data = barChartData
        
    }
    
    // MARK: - Core Location
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var userLocation:CLLocation = locations[0] as! CLLocation
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        
        print("LAT: \(lat), LONG: \(long)")
    }


}

