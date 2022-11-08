//
//  LoginView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 03/11/22.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let storedUsername = "ajeje"
let storedPassword = "brazof"

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var authenticationDidFail: Bool = false
    @State private var authenticationDidSucceed: Bool = false
    
    @State private var editingMode: Bool = false
    
    enum AuthenticationStatus: String, Codable, CaseIterable {
        case notAuthenticated
        case guest // TODO: Extra feature?
        case inProgress
        case failed
        case authenticated
    }
    @Binding var authenticationStatus: AuthenticationStatus
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                
                Image("black_kiwi")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .padding(.bottom, 75)
                
                TextField("Username", text: $username, onEditingChanged: {edit in
                    if edit == true
                    {self.editingMode = true}
                    else
                    {self.editingMode = false}
                })
                
                
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .disableAutocorrection(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                
                if authenticationStatus == .failed {
                    Text("Information not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                Button(action: {
                    if username == storedUsername && password == storedPassword {
                        authenticationStatus = .authenticated
                    } else {
                        authenticationStatus = .failed
                    }
                }) {
                    switch (authenticationStatus) {
                    case .notAuthenticated, .guest:
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    case .failed:
                        Text("RETRY")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.red)
                            .cornerRadius(15.0)
                    case .inProgress, .authenticated:
                        HStack {
                            Text("LOGGING IN")
                                .font(.headline)
                            ProgressView(value: 5)
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.leading)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                    }
                }
            }
            .padding()
            if authenticationStatus == .authenticated {
                // TODO: This is useless if when authenticated change screen
                withAnimation(.default) {
                    Text("Login succeeded!")
                        .font(.headline)
                        .frame(width: 250, height: 80)
                        .background(Color.green)
                        .cornerRadius(20.0)
                        .foregroundColor(.white)
                }
            }
        }
        .offset(y: editingMode ? -150 : 0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authenticationStatus: .constant(LoginView.AuthenticationStatus.notAuthenticated))
    }
}
