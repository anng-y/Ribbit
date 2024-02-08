//
//  UserModel.swift
//  Ribbit
//
//  Created by Ann Yip on 1/30/24.
//

import SwiftUI

@MainActor class UserModel: ObservableObject {
    @Published var user: User?
    @Published var authToken: String?
    @Published var username: String
    @Published var totalAmount: Double
    @Published var accountExist: Bool
    
    init() {
        // set the variables to nil, call the member functions later to update it
        user = nil
        authToken = nil
        username = ""
        totalAmount = 0.0
        accountExist = false
    }
    
    // once there is a user object saved, check if account exists
    func findAccount() {
        if self.user?.accounts.count != 0{
            self.accountExist = true  // if account exist
            return
        }
    }
    
    // called once an authtoken is found
    func initialize(authToken: String) async {
        self.authToken = authToken
        UserDefaults.standard.setValue(self.authToken, forKey: "authtoken")
        do {
            let userResponse = try await Api.shared.user(authToken: authToken)
            self.user = userResponse.user
            self.username = self.user?.name ?? ""
            self.findAccount()
            self.getTotalAmount()
        } catch {
            print("Cannot get User")
        }
    }
    
    // changes and set userName in server and userdefaults
    func changeUserName(newName: String) async {
        if let authToken = self.authToken {
            do {
                let userResponse = try await Api.shared.setUserName(authToken: authToken, name: newName)
                self.user = userResponse.user
                UserDefaults.standard.set(newName, forKey: "username")
            } catch {
                print("Cannot change username")
            }
        }
    }
    
    // Get Total Amount
    func getTotalAmount() {
        var totalAmount = 0.0
        
        if let user = self.user {
            for account in user.accounts {
                totalAmount = totalAmount + account.balanceInUsd()
            }
        }
        
        return self.totalAmount = totalAmount
    }

    // Get the number of accounts
    func accountNumber() -> Int {
        return user?.accounts.count ?? 0
    }
    
    // resets everything
    func logout() {
        user = nil
        authToken = nil
        username = ""
        accountExist = false
        
        UserDefaults.standard.removeObject(forKey: "authtoken")
    }
    
    // Create New Account
    func createAccount(accountName: String) async {
        // Account name has to be non-empty
        if (accountName == "") {
            return
        }
        
        // API request
        if let authToken = self.authToken {
            do {
                let userResponse = try await Api.shared.createAccount(authToken: authToken, name: accountName)
                self.accountExist = true
                self.user = userResponse.user
            }
            catch {
                print("Cannot create new account")
            }
        }
    }
    
    // Deposit
    func deposit(account: Account, amountInCents: Int) async -> Bool {
        do {
            // Api request
            let userResponse = try await Api.shared.deposit(authToken: self.authToken ?? "", account: account, amountInCents: amountInCents)
            self.user = userResponse.user
            getTotalAmount()
            return true
        } catch {
            print("Cannot deposit")
            return false
        }
    }
    
    // Withdraw
    func withdraw(account: Account, amountInCents: Int) async -> Bool {
        do {
            // Api reequest
            let userResponse = try await Api.shared.withdraw(authToken: self.authToken ?? "", account: account, amountInCents: amountInCents)
            self.user = userResponse.user
            getTotalAmount()
            return true
        } catch {
            print("Cannot withdraw")
            return false
        }
    }
    
    // Transfer
    func transfer(from: Account, to: Account, amountInCents: Int) async -> Bool {
        do {
            // Api request
            let userResponse = try await Api.shared.transfer(authToken: self.authToken ?? "", from: from, to: to, amountInCents: amountInCents)
            self.user = userResponse.user
            getTotalAmount()
            // if true it will dismiss the screen
            return true
        } catch {
            print("Cannot transfer")
            // if false it will display error message and not dismiss the screen
            return false
        }
    }
    
    // Delete Account
    func deleteAccount(account: Account) async {
        // API request
        if let authToken = self.authToken {
            do {
                let userResponse = try await Api.shared.deleteAccount(authToken: authToken, account: account)
                self.user = userResponse.user
                self.accountExist = accountNumber() > 0 ? true : false
                getTotalAmount()
            }
            catch {
                print("Cannot delete the account")
            }
        }
    }
}
