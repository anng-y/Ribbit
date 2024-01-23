//
//  LaunchView.swift
//  Ribbit
//
//  Created by Ann Yip on 1/17/24.
//  919530072
//

import SwiftUI

struct LaunchView: View {
    // Variables
    // Referenced https://www.youtube.com/watch?v=lBCpwYDljwI&t=938s&ab_channel=Rebeloper-RebelDeveloper
    @State var isActive = false
    @State var size = CGSize(width: 2.5, height: 2.5)
    @State var opacity = 0.5
    
    var body: some View {
        if isActive {
            VerificationView()
        } else {
            VStack {
                VStack {
                    Image("pixelFrog")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                    Text("Ribbit")
                        .font(Font.custom("RetroGaming", size: 25, relativeTo: .title2))
                        .fontWeight(.medium)
                }
                // ScaleAnimation
                .scaleEffect(size)
            }
            .opacity(opacity)
            // Dismiss animation
            .onAppear {
                withAnimation(.easeOut(duration: 2)) {
                    self.size = CGSize(width: 1, height: 1)
                    self.opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute : {
                    withAnimation(.easeIn(duration: 1)){
                        size = CGSize(width:50, height: 50)
                        opacity = 0
                    }
                    self.isActive = true
                })
            }
        }
    }
}

#Preview {
    LaunchView()
}
