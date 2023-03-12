//
//  Extension+Int.swift
//  Skillbox Drive
//
//  Created by Bandit on 08.02.2023.
//

import Foundation

extension Int {
    
    func formatterForSizeCharts () -> Double {
        var number: Double
        if self >= 1024 {
            number = Double((Double(self)/1024)/1024)
            return number
        }
        return Double(self)
    }
    
    func formatterForSizeValueFile () -> String  {
            switch self {
            case ...1023:
                return "\(self) \(Constans.Text.profileLabelUnitBt)"
            case 1024...1048575:
                let text = Double(Double(self)/1024)
                return "\((String(format: "%.0f", text))) \(Constans.Text.profileLabelUnitKb)"
            case 1048576...1073741823:
                let text = Double((Double(self)/1024)/1024)
                return "\((String(format: "%.0f", text))) \(Constans.Text.profileLabelUnitMb)"
            case 1073741824...:
                let text = Double(Double((Double(self)/1024)/1024)/1024)
                return "\((String(format: "%.0f", text))) \(Constans.Text.profileLabelUnitGb)"
            default: print ("\(self) вне диапазона")
                break
            }
        return "\(self) \(Constans.Text.profileLabelUnitBt)"
    }
}
