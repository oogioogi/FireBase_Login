//
//  LoginViewController.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/02.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        self.dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccount), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func tappedLoginButton() {
        guard let email = userEmailTextField.text else { return }
        guard let password = userPasswordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(" 파이어 베이스 로그인에 실패했습니다!.: \(error) ")
                return
            }
            
            let navigation = self.presentingViewController as! UINavigationController
            let userListViewController = navigation.viewControllers[navigation.viewControllers.count - 1] as? UserListViewController
            //print("navigation.viewControllers.count :", navigation.viewControllers.count)
            userListViewController?.fetchLoginUserInfo()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc private func tappedDontHaveAccount() {
        self.navigationController?.popViewController(animated: true)
    }
}
