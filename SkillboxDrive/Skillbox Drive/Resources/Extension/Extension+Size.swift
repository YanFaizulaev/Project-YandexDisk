//
//  Extension+Size.swift
//  Skillbox Drive
//
//  Created by Bandit on 13.02.2023.
//

import UIKit

extension FirstViewController {
    
    func sizeView () -> CGFloat {
        let width  = view.frame.width
        switch width {
        case ...375:
            return 70.0
        case 376...386:
            return 80.0
        case 387...:
            return 90.0
        default:
            break
        }
    return 70
    }
    
}
