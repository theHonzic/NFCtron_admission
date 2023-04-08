//
//  DailyViewModel.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import Foundation
import SwiftUI

@MainActor final class DailyViewModel: ObservableObject {
    @Published var pod: APIPod?
    @Published var thumbnail: Image?
    @Published var image: Image?
}


extension DailyViewModel {
    func provideData() async {
        let url: URL = URLConstants.podURL
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try? JSONDecoder().decode(APIPod.self, from: data)
            self.pod = response.self
            print(String(describing: response))
        } catch {
            print(error.localizedDescription)
        }
    }
}
