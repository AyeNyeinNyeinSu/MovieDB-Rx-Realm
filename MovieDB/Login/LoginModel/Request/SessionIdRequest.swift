//
//  SessionIdRequest.swift
//  MovieDB
//
//  Created by MgKaung on 01/09/2023.
//

import Foundation

struct SessionIdRequest: Codable {
    
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
    
}
