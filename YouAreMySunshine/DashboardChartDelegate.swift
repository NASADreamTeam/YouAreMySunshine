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
     //   chartView.getHighlightByTouchPoint(<#T##pt: CGPoint##CGPoint#>)
        print("CHART SELECTED: \(entry)....")
        print("entry.data: \(entry.data)")
        print("entry.description: \(entry.description.description)")
      //  print("entry.xIndex: \(entry.xIndex)")
        print("---")
        print("chartView.chartDescription: \(chartView.chartDescription)")
        print("chartView.centerOffsets: \(chartView.centerOffsets)")
        print("chartView.contentRect: \(chartView.contentRect)")
        
        print("highlight \(highlight.dataIndex)")
        print("highlight \(highlight.dataSetIndex)")
        print("highlight \(highlight.stackIndex)")

        //print("entry.: \(entry.value(forKey: <#T##String#>))")
        //activeApplianceList makes up graph
        // get index of item that we selected.
        
        //Segue to detail view

    }
    
}
