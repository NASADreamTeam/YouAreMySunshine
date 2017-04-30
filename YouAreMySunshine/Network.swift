//
//  Network.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/30/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    // times intervals fetched are 30 min increments.
    static func fetchPredictedIrradiance(lat: Double, long: Double) -> Double {
        let url = "https://api.solcast.com.au/radiation/forecasts?longitude=\(long)&latitude=\(lat)&capacity=10&api_key=uos_eam6ozSnecTk5pTerz5ow-r916Uc&format=csv"
        //let url = "http://echolynx.com"
        guard let myURL = URL(string: url) else{
            print("error")
            return 0.0
        }
        do {
            let CSV = try String(contentsOf: myURL, encoding: .ascii)
            let lines = CSV.components(separatedBy: "\n")
            var sum = 0.0
            for index in stride(from: 1, through:48, by: 1) {
                let element = lines[index]
                let values = element.components(separatedBy: ",")
                sum = sum + Double(values[0])!
            }
            sum = sum * 0.5
            print("Watt hours per m^2: \(sum)") // Total watt hours
            return sum
            
        } catch let error {
            print("Error \(error)")
            return 0.0
        }
    }
    
}
