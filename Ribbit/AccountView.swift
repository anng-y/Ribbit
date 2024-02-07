//
//  AccountOperationView.swift
//  Ribbit
//
//  Created by Ann Yip on 2/6/24.
//

import SwiftUI

struct AccountView: View {
    @Binding var account: Account
    @State var amount: Int = 0
    var body: some View {
        HStack {
            Text(account.name)
                .font(Font.custom("RetroGaming", size: 25, relativeTo: .title))
                .multilineTextAlignment(.leading)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Spacer()
        }
//        TextField("Amount", text: $amount)
        
    }
}

#Preview {
    AccountView(account: .constant(Account(name: "Bank", id: "1", balance: 100)))
}
