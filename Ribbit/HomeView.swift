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
    
    // Delete Account from the list
    func delete(_ offsets: IndexSet) async {
                
        let index = offsets[offsets.startIndex]
        let deletedAccount = userModel.user?.accounts[index]
        
        if let deletedAccount = deletedAccount {
            await userModel.deleteAccount(account: deletedAccount)
            
            // Update total amount after deletion
            totalAmount = userModel.getTotalAmount()
        }
        else {
            print("Failed deleting account")
        }
    }
    
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
                if let accounts = userModel.user?.accounts {
                    if accounts.count > 0 {
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
                            // Delete the account
                            .onDelete(perform: { indexSet in
                                Task {
                                    await delete(indexSet)
                                }
                            })
                        }
                        .listStyle(.inset)
                    }
                    // Instruction if no accounts exist
                    else {
                        Text("Create an account in settings.")
                            .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                    }
                }
            }
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
