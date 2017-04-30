//
//  DashboardCollectionViewDelegate.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit
import Charts

extension DashboardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        let freeValue = activeApplianceList.filter { $0.name == "Free" }.first?.energyUsage
        
        // get the initial value of the item selected
        let itemValue = applianceList[indexPath.row].energy
        
        // multiply initial value by time to get the cost of using the appliance @ max time
        let upperBound = ((freeValue! / itemValue) * 60) * 60
        print("Upper bound: \(upperBound)")
        
        if upperBound != 0.0 {
            selectedUpperBound = upperBound // set upperbound
                if let selectedItems = collectionView.indexPathsForSelectedItems {
                    if selectedItems.contains(indexPath) {
                        collectionView.deselectItem(at: indexPath, animated: true)
                        return false
                    }
                }
                return true
            
        } else {
            // Not possible to use appliance, not enough energy left even for minimal use.
            let alert = UIAlertController(title: "Error", message: "Insert error here of x amount: ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected: \(indexPath.row)")
        
        let timePrompt = storyboard?.instantiateViewController(withIdentifier: "durationView") as! TimeViewController
        timePrompt.modalPresentationStyle = .overCurrentContext
        timePrompt.selectedUpperBound = selectedUpperBound
        timePrompt.selectedIndex = indexPath
        timePrompt.selectedAppliance = applianceList[indexPath.row]
        self.present(timePrompt, animated: false, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselected item: \(indexPath.row)")
        
        let object = applianceList[indexPath.row] // retrieve the object that is being deselected
        
        let newObject = activeApplianceList.filter { $0.name == object.name }.first // retrieve the object that is being deselected from the active item list
        
        activeApplianceList = activeApplianceList.filter { $0.name != object.name } // make the active appliance list without the item that was just deselected
        
        //change the free space to = what it was before + the cost of the object being deselected
        activeApplianceList[activeApplianceList.endIndex - 1].energyUsage += (newObject?.energyUsage)!
        //reload the graph.
        let energyValue = activeApplianceList.map( { $0.energyUsage })
        updateGraph(activeAppliances: energyValue)
        
        
        //guard var total = totalEnergyUsed else { return }
        //total -= (newObject?.energyUsage)!
        totalEnergyUsed -= (newObject?.energyUsage)!
        //totalEnergyUsed = total
        averageNumberLabel.text = "Total energy: \(Int(totalEnergyUsed)) / \(Int(totalWatNumber))"

        
    }
    
    func addAppliance() {
        guard let indexPath = ShareData.sharedInstance.selectedIndex else { return }
        guard let duration = ShareData.sharedInstance.duration else { return }
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: duration)
        let hour = Double(comp.hour!)
        let minute = Double(comp.minute!) / 60
        
        let hoursSpent = hour + minute
        
        //let energyValue = activeApplianceList.filter { $0.name == "Free" }.first
        
        let itemValue = applianceList[indexPath.row].energy * hoursSpent // 25 * 3 = 75
        
        //let newValue = (energyValue?.energyUsage)! - itemValue
        //print("Active: \((energyValue?.energyUsage)!) - \(itemValue) = \(newValue)")
        //if newValue >= 0 && newValue <= 100 {
            activeApplianceList.insert(applianceList[indexPath.row], at: 0)
            activeApplianceList[0].energyUsage = itemValue // set the item being selected's value by watt * time
            activeApplianceList[0].timeUsed = duration
            activeApplianceList[activeApplianceList.endIndex - 1].energyUsage -= itemValue // subtract new amount from the free space

            //print("LIST MASTER : \(activeApplianceList.map( { $0.energyUsage }))")
            //print("POST: \(activeApplianceList[0].energyUsage)     : \(activeApplianceList[1].energyUsage)")
            
            // reload the graph
            let newEnergyValue = activeApplianceList.map( { $0.energyUsage })
            updateGraph(activeAppliances: newEnergyValue)
        
        
        //guard var total = totalEnergyUsed else { print("prob adding");return }
        totalEnergyUsed += itemValue//(newObject?.energyUsage)!
        //total += itemValue
        //totalEnergyUsed = total
        averageNumberLabel.text = "Total energy: \(Int(totalEnergyUsed)) / \(Int(totalWatNumber))"
        //} else {
            // Invalid.
        //    print("Unable to satisfy constraints")
            
       //}
        
    }
    
    
    func itemDeselect() {
        guard let indexPath = ShareData.sharedInstance.selectedIndex else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}
