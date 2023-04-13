//
//  AppBackground.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        Color("AppBackground")
            .ignoresSafeArea(.all)
    }
}

struct AppBackground_Previews: PreviewProvider {
    static var previews: some View {
        AppBackground()
    }
}
