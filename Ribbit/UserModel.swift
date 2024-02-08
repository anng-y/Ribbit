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
    @Published var phoneNumber: String
    @Published var accountExist: Bool
    
    init() {
        // set the variables to nil, call the member functions later to update it
        user = nil
        authToken = nil
        username = ""
        phoneNumber = "+10123456789"
        
        accountExist = false
    }
    
    func initUsername (user: User) {
        guard let userName = UserDefaults.standard.string(forKey: "username") else {
            self.username = user.name ?? ""
            return
        }
        self.username = userName
    }
    
    // saves phone number in
    func initPhoneNumber (user: User) {
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phonenumber") else {
            self.phoneNumber = user.e164PhoneNumber
            UserDefaults.standard.set(self.phoneNumber, forKey: "phoneNumber")
            return
        }
        self.phoneNumber = phoneNumber
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
            self.initUsername(user: userResponse.user)
            self.initPhoneNumber(user: userResponse.user)
            self.findAccount()
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
    func getTotalAmount() -> Double {
        var totalAmount = 0.0
        
        if let user = self.user {
            for account in user.accounts {
                totalAmount = totalAmount + account.balanceInUsd()
            }
        }
        
        return totalAmount
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
        phoneNumber = ""
        accountExist = false
        
        
        UserDefaults.standard.removeObject(forKey: "authtoken")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "phonenumber")
        
    }
    
    //    func setPhoneNumber(phoneNumber: String) {
    //        if let user = self.user {
    //            user.e164PhoneNumber = phoneNumber
    //        }
    //    }
    
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
    
    func deposit(account: Account, amountInCents: Int) async -> Bool {
        do {
            let userResponse = try await Api.shared.deposit(authToken: self.authToken ?? "", account: account, amountInCents: amountInCents)
            self.user = userResponse.user
            return true
        } catch {
            print("Cannot deposit")
            return false
        }
    }
    
    func withdraw(account: Account, amountInCents: Int) async -> Bool {
        do {
            let userResponse = try await Api.shared.withdraw(authToken: self.authToken ?? "", account: account, amountInCents: amountInCents)
            self.user = userResponse.user
            return true
        } catch {
            print("Cannot withdraw")
            return false
        }
    }
    
    func transfer(from: Account, to: Account, amountInCents: Int) async -> Bool {
        do {
            let userResponse = try await Api.shared.transfer(authToken: self.authToken ?? "", from: from, to: to, amountInCents: amountInCents)
            self.user = userResponse.user
            return true
        } catch {
            print("Cannot transfer")
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
            }
            catch {
                print("Cannot delete the account")
            }
        }
    }
}
