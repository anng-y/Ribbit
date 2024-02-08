//
//  TransferView.swift
//  Ribbit
//
//  Created by Ann Yip on 2/7/24.
//

import SwiftUI

struct TransferView: View {
    @EnvironmentObject var userModel: UserModel
    @Environment(\.dismiss) var dismiss
    @Binding var fromAcct: Account
    @Binding var amountInCents: Int
    @State var errorMsg: String = ""
    @State var backToHome: Bool = false
    var body: some View {
        VStack {
            List {
                if let accounts = userModel.user?.accounts {
                    ForEach(accounts, id: \.self) { acct in
                        Button {
                            Task {
                                if await userModel.transfer(from: fromAcct, to: acct, amountInCents: amountInCents) {
                                    backToHome = true
                                } else {
                                    errorMsg = "Invalid amount."
                                }
                            }
                        } label: {
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
            }
            .listStyle(.inset)
            Text(errorMsg)
                .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                .foregroundColor(.red)
            Spacer()
        }
        .navigationDestination(isPresented: $backToHome) {
            HomeView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    TransferView(fromAcct: .constant(Account(name: "Bank", id: "1", balance: 100)), amountInCents: .constant(100))
        .environmentObject(UserModel())
}
