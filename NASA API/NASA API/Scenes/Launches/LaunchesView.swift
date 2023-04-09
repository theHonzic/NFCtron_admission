//
//  LaunchesView.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import SwiftUI

struct LaunchesView: View {
    @StateObject private var viewModel: LaunchesViewModel = .init()
    var body: some View {
        VStack {
            ForEach(viewModel.launches, id: \.id) { item in
                Text(item.name ?? "nil")
            }
        }
            .onFirstAppear {
                Task {
                    await viewModel.provideData()
                }
            }
    }
}

struct LaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchesView()
    }
}
