//
//  UserDefaultsManager.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

protocol UserDefaultsManaging {
    func isRunningForTheFirstTime() -> Bool
    func runFirst()
}

final class UserDefaultsManager: UserDefaultsManaging {
    func isRunningForTheFirstTime() -> Bool {
        if let value = UserDefaults.standard.value(forKey: "FirstRun") {
            return value as! Bool
        } else {
            return false
        }
    }
    func runFirst() {
        UserDefaults.standard.set(true, forKey: "FirstRun")
    }
}
