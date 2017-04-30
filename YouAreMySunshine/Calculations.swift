//
//  Calculations.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/30/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import Foundation

class CalculationHelper {
    
    var defaults = UserDefaults.standard
    
    static func wattHours(wattHrM2: Double) -> Double {

        guard let efficiency = UserDefaults.standard.value(forKey: "efficiency") as? Double else { return 1.0 }
        
        guard let panelArea = UserDefaults.standard.value(forKey: "panelArea") as? Double else { return 1.0 }
        
        guard let panelNumber = UserDefaults.standard.value(forKey: "panelNumber") as? Double else { return 1.0 }
        
        let wattHours = efficiency * panelArea * panelNumber * wattHrM2
        
        return wattHours
    }
    
}
