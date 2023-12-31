//
//  ResquestTokenResponse.swift
//  MovieDB
//
//  Created by MgKaung on 01/09/2023.
//

import Foundation

struct ResquestTokenResponse: Codable {
    
    let success: Bool
    let expiresAt: String?
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
