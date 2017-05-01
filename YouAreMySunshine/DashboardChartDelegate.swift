//
//  DashboardChartDelegate.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit
import Charts

extension DashboardViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Chart Selected: \(highlight.stackIndex)")
        
        if highlight.stackIndex != -1 {
            selectedIndex = highlight.stackIndex

            performSegue(withIdentifier: "dashToDetail", sender: self)
            
        }
    }
    
}
