//
//  DailyView.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import SwiftUI

struct DailyView: View {
    var body: some View {
        ZStack {
            AppBackground()
        ScrollView {
                VStack(alignment: .leading) {
                    makeImage()
                    Text("Explanation")
                        .font(.largeTitle)
                        .padding(.vertical)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum rhoncus lectus ut magna bibendum, a ultrices nisl euismod. Duis tincidunt, quam sed blandit scelerisque, erat odio convallis mi, sed aliquet libero risus eu risus. Nulla facilisi. Proin ultrices lacus in eros maximus congue. Nunc ac fermentum lacus. Aliquam a nisi ullamcorper, convallis eros vel, venenatis neque. Donec rutrum, massa sed scelerisque viverra, tellus turpis hendrerit sapien, id laoreet nisl est in est. In bibendum varius mauris non consequat. Sed ornare metus eu nibh lobortis, a bibendum est bibendum.")
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder func makeImage() -> some View {
        Image("testing")
                .resizable()
                .scaledToFit()
                
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Terran 1 burns methalox")
                                .foregroundColor(.white)
                                .font(.title2)
                                Spacer()
                        }
                        .padding(2)
                        Spacer()
                        Group {
                            Text("6. 4. 2022")
                                .foregroundColor(.gray)
                                .font(.callout)
                            Text("TODAY")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .padding(.leading)
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
