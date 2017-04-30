//
//  DashboardCollectionViewDataSource.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit

extension DashboardViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applianceList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "applianceCell", for: indexPath) as! ApplianceCollectionViewCell

        cell.layer.cornerRadius = 4.0
        cell.applianceLabel.text = applianceList[indexPath.row].name
        cell.backgroundColor = applianceList[indexPath.row].color
        cell.applianceImageView.image = applianceList[indexPath.row].image.maskWithColor(color: UIColor.white)
        
        return cell
    }
    
}
