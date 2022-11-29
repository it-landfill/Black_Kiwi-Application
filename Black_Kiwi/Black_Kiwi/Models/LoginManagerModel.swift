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
    
    static func loginUser(authenticationStatus: Binding<AuthenticationStatus>, errorMessage: Binding<String>, credentials: LoginRequest) async -> LoginResponse? {
        let endpoint = "\(AppSettings.apiURL)/login"
        
        print(credentials)
        var userData: LoginResponse?;
        DispatchQueue.main.async {
            authenticationStatus.wrappedValue = .inProgress
        }
        
        let dataTask = AF.request(endpoint, method: .post, parameters: credentials, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).serializingDecodable(LoginResponse.self)
        
        let response = await dataTask.response
        
        if (response.error != nil) {
            print("Error in login")
            debugPrint(response)
            if (response.response?.statusCode == 401) {
                errorMessage.wrappedValue = "Wrong Username or Passowrd"
            }
            DispatchQueue.main.async {
                authenticationStatus.wrappedValue = .failed
            }
            return nil
        }
        print(response.value ?? "Error pronting response")
        errorMessage.wrappedValue = ""
        
        DispatchQueue.main.async {
            authenticationStatus.wrappedValue = .authenticated
        }
        
        userData = response.value ?? nil
        
        
        return userData
    }
    
    static func logoutUser(authToken: String) async -> Bool {
        print("Requesting logout for token: \(authToken)")
        let endpoint = "\(AppSettings.apiURL)/logout"
        
        let headers: HTTPHeaders = [
            "X-API-KEY": authToken
        ]
        
        let logoutTask = AF.request(endpoint, method: .post, headers: headers).serializingString()
        let response = await logoutTask.response
        
        if (response.error != nil) {
            print("Error in logout")
            debugPrint(response)
            return false
        } else {
            return true
        }
    }
    
}
