//
//  SessionIdResponse.swift
//  MovieDB
//
//  Created by MgKaung on 01/09/2023.
//

import Foundation

struct SessionIdResponse: Codable {
    
    let success: Bool
    let sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
    
}
