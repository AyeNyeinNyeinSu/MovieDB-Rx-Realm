//
//  LoginViewModel.swift
//  MovieDB
//
//  Created by MgKaung on 01/09/2023.
//

import Foundation
import RxCocoa
import RxSwift

enum LoginResult {
    case success
    case failure
}

class LoginViewModel {
    
    struct Input {
        let userNmae: Driver<String>
        let password: Driver<String>
        let loginTap: Signal<Void>
    }

    struct Output {
        let result: Driver<LoginResult>
        let enabled: Driver<Bool>
    }

    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {

        let validUsername = input.userNmae.map({ $0.count > 0 })
        let validPassword = input.password.map({ $0.count > 4 })
        let enabled = Driver.combineLatest(validUsername, validPassword) { ($0 && $1) }

        let usernameAndPassword = Driver.combineLatest(input.userNmae, input.password) { ($0, $1) }
        let result = input.loginTap.asObservable()
            .withLatestFrom(usernameAndPassword)
            .flatMap { (userName, password) -> Observable<Bool> in
                TMDBClient.login(username: userName, password: password)
            }
            .map({ $0 ? LoginResult.success : LoginResult.failure })
            .asDriver(onErrorJustReturn: .failure)

        return LoginViewModel.Output(result: result, enabled: enabled)
    }
    
}
