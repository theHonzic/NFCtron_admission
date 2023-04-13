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
    func getInfoIn() -> String {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date.now, to: self)
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        if days < 0 || hours < 0 || minutes < 0 || seconds < 0 {
            return "Already launched"
        } else {
            return "Launch in \(days)d \(hours)h \(minutes)m \(seconds)s"
        }
    }
}
