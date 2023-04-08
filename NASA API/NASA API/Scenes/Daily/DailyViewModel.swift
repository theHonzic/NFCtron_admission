//
//  DailyViewModel.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import Foundation
import SwiftUI

@MainActor final class DailyViewModel: ObservableObject {
    @Injected private var coreDataManager: CoreDataManaging
    @Injected private var networkManager: NetworkManager
    @Published var pod: PicOfDay?
    
    var deviceIsConnected: Bool {
        return networkManager.isConnected
    }
}


extension DailyViewModel {
    func provideData() async {
        if networkManager.isConnected {
            Logger.log("Device is connected, fetching from API now...", .info)
            await fetchFromAPI()
            await saveToCoreData()
        } else {
            Logger.log("Device is not connected, fetching from Core Data now...", .info)
            await fetchFromCoreData()
        }
    }
    private func fetchFromAPI() async {
        do {
            let url: URL = URLConstants.podURL
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try? JSONDecoder().decode(APIPod.self, from: data)
            if let entity = response.self{
                self.pod = .init(from: entity)
            }
            Logger.log("Fetch completed.", .info)
        } catch {
            Logger.log("There was an error fetching picture of the day from API.\n\(error.localizedDescription)", .error)
        }
    }
    private func fetchFromCoreData() async {
        do {
            let request = CDPod.fetchRequest()
            request.sortDescriptors = [
                .init(key: "posted", ascending: false)
            ]
            let items = try coreDataManager.viewContext.fetch(request)
            if let item = items.first {
                self.pod = .init(from: item)
            }
        } catch {
            Logger.log("There was an error fetching picture of the day from Core Data.\n\(error.localizedDescription)", .error)
        }
    }
    private func saveToCoreData() async {
        do {
            removeLastFromCoreData()
            let url: URL = URLConstants.podURL
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try? JSONDecoder().decode(APIPod.self, from: data)
            if let entity = response.self{
                _ = await CDPod(from: entity, in: coreDataManager.viewContext)
            }
            Logger.log("Saved to Core Data", .success)
        } catch {
            Logger.log("There was an error saving picture of the day to Core Data.\n\(error.localizedDescription)", .error)
        }
    }
    private func removeLastFromCoreData() {
        do {
            let request = CDPod.fetchRequest()
            request.sortDescriptors = [
                .init(key: "posted", ascending: false)
            ]
            let items = try coreDataManager.viewContext.fetch(request)
            if let item = items.first {
                coreDataManager.viewContext.delete(item)
            }
            try coreDataManager.viewContext.save()
        } catch {
            Logger.log("There was an error removing picture of the day from Core Data.\n\(error.localizedDescription)", .error)
        }
    }
}
