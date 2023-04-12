//
//  LaunchesView.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct LaunchesView: View {
    @StateObject private var viewModel: LaunchesViewModel = .init()
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    if viewModel.filteredLaunches.contains { $0.pinned } {
                        makePinned()
                        Spacer()
                    }
                    if viewModel.filteredLaunches.contains { !$0.pinned } {
                        makeUnpinned()
                        Spacer()
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    makeSearchbar()
                        .padding(20)
                }
            }
        }
        .alert("Are you sure you want to unpin all launches?", isPresented: $viewModel.isAlertPresented) {
            Button("Yes") {
                Task {
                    await viewModel.unpinAll()
                }
            }
            Button("No", role: .cancel) {
                viewModel.isAlertPresented = false
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.provideData()
            }
        }
    }
    @ViewBuilder func makePinned() -> some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("Pinned")
                    .font(.title2)
                Spacer()
                Text("Unpin all")
                    .font(.caption)
                    .foregroundColor(Color("searchText"))
                    .onTapGesture {
                        viewModel.isAlertPresented = true
                    }
            }
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init(.flexible(minimum: 90, maximum: 100)), .init(.flexible(minimum: 90, maximum: 100))]) {
                    ForEach(viewModel.launches.filter { $0.pinned }, id: \.id) { item in
                        makeCard(for: item)
                            .padding()
                    }
                }
            }
        }
    }
    @ViewBuilder func makeUnpinned() -> some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("Upcoming")
                    .font(.title2)
                Spacer()
                Text("Sort by")
                    .font(.caption)
                    .foregroundColor(Color("searchText"))
            }
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init(.flexible(minimum: 90, maximum: 100)), .init(.flexible(minimum: 90, maximum: 100))]) {
                    ForEach(viewModel.launches.filter { !$0.pinned }, id: \.id) { item in
                        makeCard(for: item)
                            .padding()
                    }
                }
            }
        }
    }
    @ViewBuilder func makeSearchbar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("searchText"))
            TextField("Type in mission name or payload name...", text: $viewModel.searchedText)
                .foregroundColor(Color("searchText"))
                .font(.callout)
        }
        .padding(8)
        .background(Color("searchField"))
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    @ViewBuilder func makeCard(for launch: Launch) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if launch.patchURL != nil || launch.patchURL != .init(string: "") {
                        WebImage(url: launch.patchURL)
                            .resizable()
                            .placeholder {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                            }
                            .frame(width: 40, height: 40)
                    } else {
                        Color.white
                            .frame(width: 40, height: 40)
                    }
                    VStack(alignment: .leading) {
                        Text(launch.name)
                            .fontWeight(.semibold)
                        if let date = launch.launchDate {
                            Text("\(date.getInfoIn())")
                                .font(.caption)
                        }
                    }
                }
                HStack {
                    if let stream = launch.livestreamURL {
                        HStack(alignment: .center) {
                            Image(systemName: "play.fill")
                            Text("Livestream")
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.red)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .onTapGesture {
                            stream.openURL()
                        }
                    }
                    if let wiki = launch.wikiURL {
                        HStack(alignment: .center) {
                            Image(systemName: "link")
                            Text("Wiki")
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .onTapGesture {
                            wiki.openURL()
                        }
                    }
                }
            }
            Spacer()
            Image(systemName: "paperclip")
                .foregroundColor(launch.pinned ? Color("searchField") : .secondary)
                .padding()
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(launch.pinned ? .yellow : Color("searchField"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    Task {
                        await viewModel.togglePinned(for: launch)
                    }
                }
        }
        .frame(width: UIScreen.screenWidth * 0.85)
    }
}

struct LaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchesView()
    }
}
