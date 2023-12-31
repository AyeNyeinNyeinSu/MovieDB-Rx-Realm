//
//  LoginRequest.swift
//  MovieDB
//
//  Created by MgKaung on 01/09/2023.
//

import Foundation

struct LoginRequest: Codable {
    
    let username: String?
    let password: String?
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}
