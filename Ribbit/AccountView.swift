//
//  AccountOperationView.swift
//  Ribbit
//
//  Created by Ann Yip on 2/6/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userModel: UserModel
    @Binding var account: Account
    @FocusState var isTyping: Bool
    @State var amount: Decimal?
    
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
                Button {
                    isTyping = false
                    print("Deposit")
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
                Button {
                    isTyping = false
                    print("Withdraw")
                } label: {
                    Text("Withdraw")
                        .font(Font.custom("RetroGaming", size: 15, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(Color("bgColor"))
                        .frame(width: 120, height: 50)
                        .background(Color("buttonColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    //.padding()
                }
                Button {
                    isTyping = false
                    print("Transfer")
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
        }
    }
}

#Preview {
    AccountView(account: .constant(Account(name: "Bank", id: "1", balance: 100)))
        .environmentObject(UserModel())
}
