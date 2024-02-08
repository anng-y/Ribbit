//
//  CreateAccountView.swift
//  Ribbit
//
//  Created by JinLee on 2/6/24.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var accountName: String = ""
    @State private var showErrorMessage: Bool = false
    @FocusState private var isTyping: Bool // var for checking whether user tapped outside number te xtField
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            VStack{
                Text("Create Your Account")
                    .font(Font.custom("RetroGaming", size: 30, relativeTo: .largeTitle))
                
                HStack {
                    // Get Account Name
                    TextField("Account Name", text: $accountName)
                        .padding()
                        .focused($isTyping)
                        .font(Font.custom("RetroGaming", size: 16, relativeTo: .body))
                    
                }
                
                // Error Message
                if showErrorMessage {
                    Text("Please provide a non-empty account name.")
                        .font(Font.custom("RetroGaming", size: 12, relativeTo: .body))
                        .foregroundStyle(Color.red)
                }
                // Create Account Btn
                Button {
                    Task {
                        print("Create Account")
                        isTyping = false
                        
                        if accountName.count == 0 {
                            showErrorMessage = true
                        }
                        else {
                            // Create Account
                            await userModel.createAccount(accountName: accountName)
                            // Move Back to the HomeView
                            dismiss()
                        }
                    }
                } label: {
                    Text("Create Account")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(Color("bgColor"))
                        .frame(width: 180, height: 50)
                        .background(Color("buttonColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }
            }
        }
        // Hide Keyboard as the user taps outside the textField
        .onTapGesture {
            isTyping = false
        }
        
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
            .environmentObject(UserModel())
    }
}
