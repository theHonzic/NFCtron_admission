//
//  URL.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation
import UIKit

extension URL {
    func openURL() {
        if UIApplication.shared.canOpenURL(self) {
            UIApplication.shared.open(self)
        }
    }
}
