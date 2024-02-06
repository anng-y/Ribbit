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
    
    
}
