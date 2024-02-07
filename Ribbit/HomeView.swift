//
//  HomeView.swift
//  Ribbit
//
//  Created by Ann Yip on 1/25/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var totalAmount: Double = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                // Welcome Message
                HStack {
                    Text("Welcome back")
                        .font(Font.custom("RetroGaming", size: 25, relativeTo: .title))
                        .multilineTextAlignment(.leading)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                }
                // Total Amount
                VStack(spacing: 15) {
                    Text("Total Amount")
                    Text("$\(totalAmount, specifier: "%.2f")")
                }
                .font(Font.custom("RetroGaming", size: 35, relativeTo: .subheadline))
            }
            VStack {
                // shows a list of accounts if they exist
                //if userModel.accountExist {
                if true {
                    if let accounts = userModel.user?.accounts {
                        List {
                            // shows each of the accounts information in a list
                            ForEach(accounts, id: \.self) { acct in
                                NavigationLink(
                                    destination: AccountView(account: Binding(get: { acct }, set: { newValue in}))
                                ) {
                                    HStack {
                                        Text(acct.name)
                                            .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                                        Spacer()
                                        Text(acct.balanceString())
                                            .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                                    }
                                }
                            }
                        }
                        .listStyle(.inset)
                    }
                } else {
                    // Instruction if no accounts exist
                    Text("Create an account in settings.")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                }
            }
//            if true {//userModel.accountExist {
//                HStack {
//                    // buttons for operations
//                    Button {
//                        print("Transfer")
//                    } label: {
//                        Text("Transfer")
//                            .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("bgColor"))
//                            .frame(width: 150, height: 50)
//                            .background(Color("buttonColor"))
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .padding()
//                    }
//                    Spacer()
//                    Button {
//                        print("Withdraw")
//                    } label: {
//                        Text("Withdraw")
//                            .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
//                            .fontWeight(.regular)
//                            .foregroundColor(Color("bgColor"))
//                            .frame(width: 150, height: 50)
//                            .background(Color("buttonColor"))
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .padding()
//                    }
//                }
//            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Move to Create Account Page
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    CreateAccountView()
                        .environmentObject(userModel)
                } label: {
                    ZStack {
                        Image(systemName: "plus.circle")
                            .fontWeight(.semibold)
                    }
                }
            }
            // Move to settings page
            ToolbarItem() {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .onAppear(
            // Set the total amount as soon as view renders
            perform: {
                totalAmount = userModel.getTotalAmount()
            }
        )
    }
}


#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(UserModel())
    }
    
    
}
