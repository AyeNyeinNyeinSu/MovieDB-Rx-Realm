//
//  HttpMethods.swift
//  MovieDB
//
//  Created by MgKaung on 02/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

class HttpMethods {
    
    class func get(url: String) -> Observable<Data?> {
        guard let url = URL(string: url) else { return Observable.empty() }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
            .map { Optional.init($0) }
            .catchAndReturn(nil)
    }
    
    class func post(url: String, body: [String: Any]) -> Observable<Data?> {
        guard let url = URL(string: url) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonData
        return URLSession.shared.rx.data(request: request)
            .map { Optional.init($0) }
            .catchAndReturn(nil)
    }
    
    
    
    
    
   
    
}
