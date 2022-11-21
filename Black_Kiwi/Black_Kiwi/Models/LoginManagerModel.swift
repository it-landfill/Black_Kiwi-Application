//
//  LoginManagerModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 08/11/22.
//

import Foundation
import Alamofire

struct LoginManagerModel {
    
    struct LoginRequest: Codable {
        let username: String
        let password: String
    }
    
    struct LoginResponse: Codable {
        let username: String
        let role: Int
        let token: String
    }
    
    private static let baseURL = "http://casadiale.noip.me:62950"
    //private static let baseURL = "http://127.0.0.1:8080"
    
    static func loginUser(credentials: LoginRequest) -> LoginResponse? {
        
        let resp = AF.request("\(baseURL)/login", method: .post, parameters: credentials, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).responseDecodable(of: LoginResponse.self) { response in
            if (response.error != nil) {
                print("Error ajeje")
                debugPrint(response)
                return
            }
            
            print(response.value)
        }
        
        
        return LoginResponse(username: "ajeje", role: 1, token: "dsfg")
    }
    
}
