//
//  SettingsView.swift
//  Ribbit
//
//  Created by Ann Yip on 1/29/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userModel: UserModel
    @State var logout: Bool = false
    
    var body: some View {
        VStack {
            Form {
                // Change username
                TextField(
                    "Username",
                    text: $userModel.username
                )
                .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                // Display phone number
                Text(userModel.user?.e164PhoneNumber ?? "")
                    .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                // Display # accounts, can switch to a button later
                Text(userModel.accountExist ? "You have \(userModel.accountNumber()) accounts." : "Create an account.")
                    .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                // log out button
                Button {
                    userModel.logout()
                    logout = true
                } label: {
                    Text("Log out")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                        .foregroundColor(.red)
                }
                
            }
            .pickerStyle(.inline)
        }
        .navigationDestination(isPresented: $logout) {
            VerificationView()
                .navigationBarBackButtonHidden(true)
        }
        .toolbar {
            // Save button
            Button("Save!") {
                Task {
                    // changes username when saved
                    await userModel.changeUserName(newName: userModel.username)
                }
            }
            .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserModel())
}
