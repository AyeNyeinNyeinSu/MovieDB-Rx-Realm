//
//  ViewController.swift
//  MovieDB
//
//  Created by MgKaung on 01/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class LoginView: UIViewController {
    
    private let bag = DisposeBag()
    let viewModel = LoginViewModel()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.text = "Nyein"
        passwordTextField.text = "C@lculator1"
        
        bindViewModel()
    }
   
    
    func bindViewModel() {

        let input = LoginViewModel.Input(
            userNmae: userNameTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTap: loginButton.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)

        //show login result to UI
        output.result
            .drive(onNext: { outputResult in
                if outputResult == LoginResult.failure {
                    self.showAlert(message: "Something Went Wrong", title: "Login Fail")
                } else {
                    self.performSegue(withIdentifier: "CompleteLogin", sender: nil)
                }
            })
            .disposed(by: bag)
        
        //activityIndicator
        let loginTapped = loginButton.rx.tap
        let loading = Observable
            .from([ loginTapped.map({ (_) in true }),
                    output.result.map({ (_) in false }).asObservable() ])
            .merge()
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
        loading
            .skip(1)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
    }
    
    
    func showAlert(message: String, title: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true)
        }
    }
    
    
}

