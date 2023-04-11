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
        VStack {
            Spacer()
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init(.flexible(minimum: 50, maximum: 100)), .init(.flexible(minimum: 50, maximum: 100))]) {
                    ForEach(viewModel.launches.filter { $0.pinned }, id: \.id) { item in
                        makeCard(for: item)
                            .padding()
                    }
                }
            }
            Spacer()
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init(.flexible(minimum: 50, maximum: 100)), .init(.flexible(minimum: 50, maximum: 100))]) {
                    ForEach(viewModel.launches.filter { !$0.pinned }, id: \.id) { item in
                        makeCard(for: item)
                            .padding()
                    }
                }
            }
            Spacer()
        }
        .onFirstAppear {
            Task {
                await viewModel.provideData()
            }
        }
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
                            Text("Launch in \(date.formatted(date: .numeric, time: .omitted))")
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
                .foregroundColor(launch.pinned ? .white : .secondary)
                .padding()
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(launch.pinned ? .yellow : .white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    Task {
                        await viewModel.togglePinned(for: launch)
                    }
                }
        }
        .frame(width: UIScreen.screenWidth * 0.9)
    }
}

struct LaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchesView()
    }
}
