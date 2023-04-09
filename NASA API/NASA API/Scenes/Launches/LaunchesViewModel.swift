//
//  LaunchesViewModel.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

@MainActor final class LaunchesViewModel: ObservableObject {
    @Injected private var apiManager: APIManaging
    @Published var launches: [APILaunch] = .init()
}

extension LaunchesViewModel {
    func provideData() async {
        self.launches = await apiManager.fetchLaunches()
    }
}
