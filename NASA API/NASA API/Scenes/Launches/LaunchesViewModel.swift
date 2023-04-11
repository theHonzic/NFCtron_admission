//
//  LaunchesViewModel.swift
//  NASA API
//
//  Created by Jan Janovec on 09.04.2023.
//

import Foundation

@MainActor final class LaunchesViewModel: ObservableObject {
    @Injected private var apiManager: APIManaging
    @Injected private var coreDataManager: CoreDataManaging
    @Injected private var userDefaultsManager: UserDefaultsManaging
    @Published var launches: [Launch] = .init()

}

extension LaunchesViewModel {
    func provideData() async {
        if !userDefaultsManager.isRunningForTheFirstTime() {
            Logger.log("Providing data for launches. Running for the first time", .info)
            await fetchLaunchesFromAPI()
            await fetchLaunchesFromCoreData()
            userDefaultsManager.runFirst()
        } else {
            Logger.log("Providing data for launches. Not running for the first time", .info)
            await fetchLaunchesFromCoreData()
            userDefaultsManager.runFirst()
        }
    }
    func togglePinned(for launch: Launch) async {
        do {
            let request = CDLaunch.fetchRequest()
            let items = try coreDataManager.viewContext.fetch(request)
            if let item = items.first(where: { $0.id == launch.id} ) {
                if item.pinned {
                    item.pinned = false
                } else {
                    item.pinned = true
                }
                try coreDataManager.viewContext.save()
            }
        } catch {
            Logger.log("There was an error removing picture of the day from Core Data.\n\(error.localizedDescription)", .error)
        }
        await fetchLaunchesFromCoreData()
    }
    private func fetchLaunchesFromAPI() async {
        let objects = await apiManager.fetchLaunches()
        for object in objects {
            _ = CDLaunch(from: object, in: coreDataManager.viewContext)
        }
    }
    private func fetchLaunchesFromCoreData() async {
        do {
            launches.removeAll()
            let request = CDLaunch.fetchRequest()
            request.sortDescriptors = [
                .init(key: "launchDate", ascending: true)
            ]
            let items = try coreDataManager.viewContext.fetch(request)
            for item in items {
                launches.append(.init(from: item))
            }
        } catch {
            Logger.log("There was an error removing picture of the day from Core Data.\n\(error.localizedDescription)", .error)
        }
    }
}
