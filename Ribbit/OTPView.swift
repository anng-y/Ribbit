//
//  OTPView.swift
//  Ribbit
//
//  Created by Ann Yip on 1/23/24.
//

import SwiftUI

struct OTPView: View {
    @Binding var phoneNumber: String
    // Focus is always on
    @FocusState private var focus: Bool
    
    // Container for the pin
    @State var pin: String = ""
    // Turns the textbox red when it is wrong.
    @State var correctPin: Bool = true
    // Allows the view to move on once OTP is verified
    @State var navigateToHome: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Text("Enter your OTP")
                .font(Font.custom("RetroGaming", size: 30, relativeTo: .largeTitle))
            Text("A 6-digit code was sent to your phone.")
                .font(Font.custom("RetroGaming", size: 12, relativeTo: .subheadline))
                .padding(.all, 1.0)
            HStack (spacing: 20, content: {
                ForEach(0..<6, id: \.self) { index in
                    let pinArr = Array(pin)
                    if pin.count > index {
                        // Text box that contains the numbers.
                        Text(String(pinArr[index]))
                            .multilineTextAlignment(.center)
                            .font(Font.custom("RetroGaming", size: 30, relativeTo: .title))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 40, height: 70)
                            .border(Color("fontColor"))
                            .foregroundColor(correctPin ? Color("fontColor") : .red)
                            .tag(index)
                    } else {
                        // if the text field has not enough numbers, still make empty boxes
                        Text("")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("RetroGaming", size: 30, relativeTo: .title))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 40, height: 70)
                            .border(Color("fontColor"))
                            .foregroundColor(Color("fontColor"))
                            .tag(index)
                    }
                }
            })
            // invisible textfield
            TextField("", text: $pin)
                .opacity(0)
                .focused($focus)
                .keyboardType(.numberPad)
                .onChange(of: pin) { oldValue, newValue in
                    if pin.count > 6 {
                        // so that the pin never gets more than 6 digit
                        pin = oldValue
                    }
                    if(pin.count == 0) {
                        correctPin = true // Resets the color if it is correct
                    }
                    if(pin.count == 6) {
                        // Verify OTP code
                        Task {
                            do {
                                let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: phoneNumber, code: pin)
                                navigateToHome = true
                            }
                            catch {
                                correctPin = false
                            }
                        }
                    }
                    
                }
            HStack {
                        Text("Don't see it?")
                            .font(Font.custom("RetroGaming", size: 14, relativeTo: .body))
                        Button {
                            // Resend OTP
                            Task {
                                do {
                                    let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: phoneNumber)
                                    navigateToHome = true
                                }
                                catch let apiError as ApiError {
                                    print (apiError.message)
                                }
                            }
                        } label: {
                            Text("Resend OTP")
                                .underline()
                                .font(Font.custom("RetroGaming", size: 14, relativeTo: .body))
                        }
                    }
                    .padding()
                    Spacer()
        }.onAppear{
            // Always focused
            self.focus = true
        }
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView()
                .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    OTPView(phoneNumber: .constant("+15001234567"))
}
