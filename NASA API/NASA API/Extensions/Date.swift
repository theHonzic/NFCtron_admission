//
//  Date.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

extension Date {
    func timeAgoString() -> String {
        let calendar = Calendar.current
        let now = Date.now
        
        let components = calendar.dateComponents([.day], from: self, to: now)
        
        if let days = components.day {
            if days == 0 {
                return "Today"
            } else if days == 1 {
                return "Yesterday"
            } else {
                return "\(days) days ago"
            }
        } else {
            return ""
        }
    }
}
