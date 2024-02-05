//
//  VerificationView.swift
//  Ribbit
//
//  Created by Ann Yip on 1/14/24.
//  919530072

import SwiftUI
import PhoneNumberKit


// Validating phone number pattern
func isValidPhoneNumber(value: String) -> Bool {
    let phoneNumberPattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
    return NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern).evaluate(with: value)
}

struct VerificationView: View {
    
    // Formatting phone number
    let phoneNumberKit = PhoneNumberKit()
    // Displaying phone number
    @State private var phoneNumber: String = ""
    @State private var phoneNumberContainer: String = ""
    // CountryCode: default = +1
    @State private var countryCode = "+1"
    // Managing keyboard/focus
    @FocusState private var isTyping: Bool
    // Validation
    @State private var isValidNum = false
    // To print message
    @State private var message = ""
    // Navigate to OTP Screen
    @State private var navigateToOTP = false
    
    var body: some View {
        ZStack {
            // Manage tap gesture
            Rectangle()
                .fill(Color("bgColor"))
                .ignoresSafeArea()
            VStack {
                Spacer()
                // Title
                Text("Verify your phone number")
                    .font(Font.custom("RetroGaming", size: 30, relativeTo: .largeTitle))
                // Phone number text field
                HStack() {
                    // Country code button, to be implemented later
                    Button (action: {
                        // country code logic
                    }, label: {
                        Text(countryCode)
                            .padding(.leading, 50.0)
                            .font(Font.custom("RetroGaming", size: 16, relativeTo: .body))
                            .foregroundColor(Color("fontColor"))
                    })
                    // Textfield for phone number input
                    TextField("(012) 345-6789", text: $phoneNumber)
                        .padding()
                        .keyboardType(.numberPad)
                        .font(Font.custom("RetroGaming", size: 16, relativeTo: .body))
                        .focused($isTyping)
                        .onChange(of: phoneNumber) { oldValue, newValue in
                            phoneNumber = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: "US")
                                .formatPartial(newValue)
                        }
                }.padding([.leading, .bottom, .trailing], 10.0)
                
                // Error or success message if there is any
                Text(message)
                    .font(Font.custom("RetroGaming", size: 10, relativeTo: .largeTitle))
                    .fontWeight(.regular)
                    .foregroundColor(isValidNum ? Color.green : Color.red)
                
                
                Spacer()
                // Bottom button
                HStack{
                    
                    Spacer()
                    Button {
                        // Actions when clicked
                        isTyping = false
                        // Calls the function for checking if phone number
                        isValidNum = isValidPhoneNumber(value: phoneNumber)
                        if isValidNum {
                            // parse phoneNumber
                            do {
                                let parsed = try phoneNumberKit.parse("+1" + phoneNumber)
                                // save as type e164
                                phoneNumberContainer = phoneNumberKit.format(parsed, toType: .e164)
                            }
                            catch {
                                print("Parse error")
                            }
                            message = "We've sent your OPT code to \(phoneNumber)"
                            Task {
                                do {
                                    let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: phoneNumberContainer)
                                    navigateToOTP = true
                                }
                                catch let apiError as ApiError {
                                    print (apiError.message)
                                }
                            }
                        } else {
                            // phone number is too short
                            if phoneNumber.count < 14 {
                                message = "Phone number is too short."
                            } else {
                                message = "Invalid phone number."
                            }
                        }
                    } label: {
                        // Beautifying
                        Text("Send")
                            .font(Font.custom("RetroGaming", size: 20, relativeTo: .title2))                            .fontWeight(.regular)
                            .foregroundColor(Color("bgColor"))
                            .frame(width: 100, height: 60)
                            .background(Color("buttonColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.trailing, 15.0)
                    }
                }
            }
            
        }
        .onTapGesture {
            isTyping = false
        }
        .navigationDestination(isPresented: $navigateToOTP) {
            OTPView(phoneNumber: $phoneNumberContainer)
        }
    }
}

#Preview {
    VerificationView()
}
