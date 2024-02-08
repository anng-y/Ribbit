//
//  AccountOperationView.swift
//  Ribbit
//
//  Created by Ann Yip on 2/6/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userModel: UserModel
    @Environment(\.dismiss) var dismiss
    @Binding var account: Account
    @FocusState var isTyping: Bool
    @State var amount: Double?
    @State var errorMsg: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(account.name)
                    .font(Font.custom("RetroGaming", size: 25, relativeTo: .title))
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                Spacer()
            }
            HStack {
                Text(account.balanceString())
                    .font(Font.custom("RetroGaming", size: 25, relativeTo: .title))
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                Spacer()
            }
        }
        VStack {
            TextField("Amount", value: $amount, format: .number.precision(.fractionLength(2)))
                .padding()
                .keyboardType(.decimalPad)
                .font(Font.custom("RetroGaming", size: 16, relativeTo: .body))
                .focused($isTyping)
            
            HStack {
                // Deposit button
                Button {
                    isTyping = false
                    // Api request
                    Task {
                        if await userModel.deposit(account: account, amountInCents: Int(amount ?? 0) * 100) {
                            // dismiss when success
                            dismiss()
                        } else {
                            errorMsg = "Invalid amount."
                        }
                    }
                } label: {
                    Text("Deposit")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(Color("bgColor"))
                        .frame(width: 120, height: 50)
                        .background(Color("buttonColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading)
                }
                // Withdraw button
                Button {
                    isTyping = false
                    Task {
                        // Api request
                        if await userModel.withdraw(account: account, amountInCents: Int(amount ?? 0) * 100) {
                            // dismiss when success
                            dismiss()
                        } else {
                            errorMsg = "Invalid amount."
                        }
                    }
                } label: {
                    Text("Withdraw")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(Color("bgColor"))
                        .frame(width: 120, height: 50)
                        .background(Color("buttonColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                // Transfer
                // Goes to the page with a list of accounts
                NavigationLink {
                    TransferView(fromAcct: $account, amountInCents: .constant(Int(amount ?? 0) * 100))
                } label: {
                    Text("Transfer")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(Color("bgColor"))
                        .frame(width: 120, height: 50)
                        .background(Color("buttonColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.trailing)
                }
            }
            Text(errorMsg)
                .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                .foregroundColor(.red)
            
        }
    }
}

#Preview {
    AccountView(account: .constant(Account(name: "Bank", id: "1", balance: 100)))
        .environmentObject(UserModel())
}
