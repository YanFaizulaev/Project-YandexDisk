//
//  Extension+String.swift
//  Skillbox Drive
//
//  Created by Bandit on 08.02.2023.
//

import Foundation

extension String {
    
    func dateFormater () -> String {

        let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+4:00")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self) ?? Date()

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let dateComponents = calendar.date(from:components) ?? Date()
        
        let dateFormatterStr = DateFormatter()
        dateFormatterStr.dateFormat = "dd.MM.yy HH:mm"
        let newDate = dateFormatterStr.string(from: dateComponents)
        return newDate
    }
    
}

