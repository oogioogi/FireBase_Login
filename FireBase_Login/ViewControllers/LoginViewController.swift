//
//  LoginViewController.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/02.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccount), for: .touchUpInside)
    }
    
    @objc private func tappedDontHaveAccount() {
        self.navigationController?.popViewController(animated: true)
    }
}
