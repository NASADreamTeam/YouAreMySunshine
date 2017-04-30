//
//  Singleton.swift
//  YouAreMySunshine
//
//  Created by Joseph Erlandson on 4/29/17.
//  Copyright © 2017 JosephErlandson. All rights reserved.
//

import UIKit

class ShareData {
    class var sharedInstance :ShareData {
        struct Singleton {
            static let instance = ShareData()
        }
        
        return Singleton.instance
    }
    
    var selectedIndex: IndexPath!
    var duration: Date!

}
