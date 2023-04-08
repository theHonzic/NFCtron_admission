//
//  Date.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

extension Date {
    func inFormat(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
