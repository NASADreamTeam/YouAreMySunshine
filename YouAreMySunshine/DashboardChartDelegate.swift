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
        print("CHART SELECTED: \(entry)....")
        
        //Segue to detail view

    }
    
}
