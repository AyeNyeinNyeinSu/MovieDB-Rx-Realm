//
//  TMDBClient.swift
//  MovieDB
//
//  Created by MgKaung on 04/09/2023.
//

import Foundation
import RxCocoa
import RxSwift

class TMDBClient {
   
    struct Endpoints {
        static let baseurl = "https://api.themoviedb.org/3"
        static let apiKey = "?api_key=b6b19e47076cb06aedb36364a162ba56"
    }
    
    class func getResquestToken() -> Observable<String?> {

        return HttpMethods.get(url: "\(Endpoints.baseurl)/authentication/token/new\(Endpoints.apiKey)")
            .map({ data -> String? in
                guard let data = data,
                      let response = try? JSONDecoder().decode(ResquestTokenResponse.self, from: data) else { return nil }
                return response.requestToken
            })
    }

    
    class func login(username: String?, password: String?) -> Observable<Bool> {
        
        return getResquestToken()
            .flatMap({ token -> Observable<Data?> in
                let token = token
                return HttpMethods.post(url: "\(Endpoints.baseurl)/authentication/token/validate_with_login\(Endpoints.apiKey)", body: ["username" : username ?? "", "password" : password ?? "", "request_token" : token ?? "" ])
            })
            .map({ data -> Bool in
                guard let data = data,
                      let response = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                          return false
                      }
                return response.success
            })
    }
    
    class func getPopularMovies() -> Observable<[PopularMovieResult]> {
        
        return HttpMethods.get(url: "\(Endpoints.baseurl)/movie/popular\(Endpoints.apiKey)")
            .map({ data -> [PopularMovieResult] in
                guard let data = data,
                      let response = try? JSONDecoder().decode(PopularMovieModel.self, from: data) else {
                          return []
                  }
                return response.results
            })
    }


    
    
    
    
    //    class func createSessionId() -> Observable<String?> {
    //        //let body = SessionIdRequest(requestToken: Auth.requestToken)
    //        return HttpMethods.post(url: "\(Endpoints.createSessionId)", body: ["request_token" : Auth.requestToken])
    //            .map({ data -> String? in
    //                guard let data = data,
    //                      let response = try? JSONDecoder().decode(SessionIdResponse.self, from: data) else {
    //                          return nil
    //                  }
    //                Auth.sessionId = response.sessionId ?? ""
    //                return response.sessionId
    //            })
    //    }
}
