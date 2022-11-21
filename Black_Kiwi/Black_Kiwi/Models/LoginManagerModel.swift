//
//  LoginManagerModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 08/11/22.
//

import Foundation
import Alamofire
import SwiftUI

struct LoginManagerModel {
    
    struct LoginRequest: Codable {
        let username: String
        let password: String
        let role: Int
    }
    
    struct LoginResponse: Codable {
        let username: String
        let role: Int
        let token: String
    }
    
    enum AuthenticationStatus: String, Codable, CaseIterable {
        case notAuthenticated
        case guest // TODO: Extra feature?
        case inProgress
        case failed
        case authenticated
    }
    
    private static let baseURL = "http://casadiale.noip.me:62950"
    //private static let baseURL = "http://127.0.0.1:8080"
    
    static func loginUser(authenticationStatus: Binding<AuthenticationStatus>, errorMessage: Binding<String>, credentials: LoginRequest) -> LoginResponse? {
        
        print(credentials)
        var userData: LoginResponse?;
        authenticationStatus.wrappedValue = .inProgress
        
        AF.request("\(baseURL)/login", method: .post, parameters: credentials, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).responseDecodable(of: LoginResponse.self) { response in
            
            if (response.error != nil) {
                print("Error in login")
                debugPrint(response)
                if (response.response?.statusCode == 401) {
                    errorMessage.wrappedValue = "Wrong Username or Passowrd"
                }
                authenticationStatus.wrappedValue = .failed
                return
            } else {
                print(response.value ?? "Error pronting response")
                errorMessage.wrappedValue = ""
                authenticationStatus.wrappedValue = .authenticated
                userData = response.value ?? nil
            }

        }
        
        return userData
        
    }
    
}
