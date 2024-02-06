
//  RootView.swift
//  Ribbit

//  Created by Ann Yip on 1/25/24.


import SwiftUI

enum RootViewType {
    case loadingView
    case newUserView
    case oldUserView
}

struct RootView: View {
    @State var rootViewType: RootViewType = .loadingView
    @StateObject var userModel = UserModel()

    var body: some View {
        VStack {
            switch rootViewType {
            case .loadingView:
                LoadingView()
                // checks authtoken
                    .onAppear {
                        Task {
                            @MainActor in
                            if let auth = UserDefaults.standard.string(forKey: "authtoken") {
                                await userModel.initialize(authToken: auth)
                                rootViewType = .oldUserView
                            } else {
                                rootViewType = .newUserView
                            }
                        }
                    }
            case .newUserView:
                NavigationStack {
                    VerificationView()
                }
                
            case .oldUserView:
                NavigationStack {
                    HomeView()
                }
            }
        }
        .environmentObject(userModel)
    }
}

#Preview {
    RootView()
        .environmentObject(UserModel())
}
