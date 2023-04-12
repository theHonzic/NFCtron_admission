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
    @Published var searchedText: String = ""
    @Published var isAlertPresented = false
    
    var filteredLaunches: [Launch] {
        return self.launches.filter { $0.upcoming }
    }
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
            if let item = items.first(where: { $0.id == launch.id }) {
                if item.pinned {
                    item.pinned = false
                } else {
                    item.pinned = true
                }
                try coreDataManager.viewContext.save()
            }
        } catch {
            Logger.log("There was an error toggling pinned.\n\(error.localizedDescription)", .error)
        }
        await fetchLaunchesFromCoreData()
    }
    func unpinAll() async {
        do {
            let request = CDLaunch.fetchRequest()
            let items = try coreDataManager.viewContext.fetch(request)
            for item in items where item.pinned {
                item.pinned = false
            }
            try coreDataManager.viewContext.save()
        } catch {
            Logger.log("There was an error unpining all.\n\(error.localizedDescription)", .error)
        }
        await fetchLaunchesFromCoreData()
    }
    private func fetchLaunchesFromAPI() async {
        Logger.log("Fetching from API.", .info)
        let objects = await apiManager.fetchLaunches()
        Logger.log("Count: \(objects.count).", .info)
        for object in objects {
            Logger.log("Writing to Core Data. \(object.id)", .info)
            _ = CDLaunch(from: object, in: coreDataManager.viewContext)
        }
    }
    private func fetchLaunchesFromCoreData() async {
        Logger.log("Fetching from Core Data.", .info)
        do {
            let request = CDLaunch.fetchRequest()
            request.sortDescriptors = [
                .init(key: "launchDate", ascending: true)
            ]
            let items = try coreDataManager.viewContext.fetch(request)
            launches.removeAll()
            for item in items where item.upcoming {
                launches.append(.init(from: item))
            }
        } catch {
            Logger.log("There was an error removing picture of the day from Core Data.\n\(error.localizedDescription)", .error)
        }
    }
}
