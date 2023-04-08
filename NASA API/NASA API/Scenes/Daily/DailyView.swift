//
//  DailyView.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct DailyView: View {
    @StateObject private var viewModel: DailyViewModel = .init()
    var body: some View {
        ZStack {
            AppBackground()
        ScrollView {
                VStack(alignment: .leading) {
                    makeImage()
                    Text("Explanation")
                        .font(.largeTitle)
                        .padding(.vertical)
                    Text(viewModel.pod?.explanation ?? "Loading...")
                }
                .padding()
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.provideData()
            }
        }
    }
    
    @ViewBuilder func makeImage() -> some View {
        WebImage(url: viewModel.pod?.hdURL)
            .placeholder{
                WebImage(url: viewModel.pod?.url)
                    .placeholder {
                        ProgressView()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(viewModel.pod?.title ?? "Loading...")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                            Spacer()
                                    }
                                    .padding(2)
                                    Spacer()
                                    Group {
                                        if let date = viewModel.pod?.date {
                                            Text("\(date.formatted(date: .numeric, time: .omitted))")
                                                .foregroundColor(.gray)
                                                .font(.callout)
                                            
                                            Text("\(date.timeAgoString())")
                                                .font(.largeTitle)
                                            .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding()
                            )
                            .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenWidth * 0.9)
                    }
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.pod?.title ?? "Loading...")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    Spacer()
                            }
                            .padding(2)
                            Spacer()
                            Group {
                                if let date = viewModel.pod?.date {
                                    Text("\(date.formatted(date: .numeric, time: .omitted))")
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                    
                                    Text("\(date.timeAgoString())")
                                        .font(.largeTitle)
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        .padding()
                    )
            }
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewModel.pod?.title ?? "Loading...")
                                .foregroundColor(.white)
                                .font(.title2)
                                Spacer()
                        }
                        .padding(2)
                        Spacer()
                        Group {
                            if let date = viewModel.pod?.date {
                                Text("\(date.formatted(date: .numeric, time: .omitted))")
                                    .foregroundColor(.gray)
                                    .font(.callout)
                                
                                Text("\(date.timeAgoString())")
                                    .font(.largeTitle)
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                )
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
