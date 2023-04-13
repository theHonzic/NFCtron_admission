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
    @Published var sortingBy: SortType = .az
    
    private var filteredLaunches: [Launch] {
        return self.launches.filter { $0.upcoming }
    }
    var pinnedLaunches: [Launch] {
        return self.filteredLaunches.filter { $0.pinned }.sorted { $0.name < $1.name }
    }
    var unpinnedLaunches: [Launch] {
        switch self.sortingBy {
        case .az:
            return self.filteredLaunches.filter { !$0.pinned }.sorted { $0.name.uppercased() < $1.name.uppercased() }
        case .za:
            return self.filteredLaunches.filter { !$0.pinned }.sorted { $0.name.uppercased() > $1.name.uppercased() }
        case .nearest:
            return self.filteredLaunches.filter { !$0.pinned }.sorted { $0.launchDate ?? .distantPast < $1.launchDate ?? .distantFuture }
        }
    }
    var searchResults: [Launch] {
        return self.filteredLaunches.filter { launch in
            let launchNameContainsText = launch.name.uppercased().contains(self.searchedText.uppercased())
            let payloadContainsText = launch.payloads.contains { payload in
                return payload.uppercased().contains(self.searchedText.uppercased())
            }
            return launchNameContainsText || payloadContainsText
        }.sorted { $0.pinned && !$1.pinned }
    }

    enum SortType {
        // swiftlint:disable:next identifier_name
        case az, za, nearest
    }
}

extension LaunchesViewModel {
    func provideData() async {
        if !userDefaultsManager.alreadyRun() {
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
    func switchSort(to type: SortType) {
        self.sortingBy = type
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
