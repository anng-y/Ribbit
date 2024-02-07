//
//  AccountOperationView.swift
//  Ribbit
//
//  Created by Ann Yip on 2/6/24.
//

import SwiftUI

struct AccountView: View {
    @Binding var account: Account
    @State var amount: Int?
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(account.name)
                    .font(Font.custom("RetroGaming", size: 25, relativeTo: .title))
                    .multilineTextAlignment(.leading)
                    .padding(.all)
            }
            HStack {
                Spacer()
                Text(account.balanceString())
                    .font(Font.custom("RetroGaming", size: 25, relativeTo: .title))
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                Spacer()
            }
            HStack {
                TextField("Amount", value: $amount, format: .number)
                    .padding()
                    .keyboardType(.numberPad)
                    .font(Font.custom("RetroGaming", size: 16, relativeTo: .body))
            }
                
        }
    }
}

#Preview {
    AccountView(account: .constant(Account(name: "Bank", id: "1", balance: 100)))
}
