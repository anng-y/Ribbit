//
//  LoadingView.swift
//  Ribbit
//
//  Created by Ann Yip on 1/30/24.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        VStack {
            Image("pixelFrog")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
        }
        VStack {
            ProgressView()
        }
    }
}

#Preview {
    LoadingView()
}
