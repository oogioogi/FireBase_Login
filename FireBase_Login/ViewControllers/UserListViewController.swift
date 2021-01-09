//
//  UserListViewController.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/02.
//

import UIKit
import Firebase

class UserListViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        confirmLoggedInUser()
    }
    
    private func setupUi() {
        let image = UIImage(named: "exit")
        // 원하는 사이즈 적용
        let scaledImage = image?.resizeImage(size: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal)
        self.logOutButton.title = ""
        self.logOutButton.image = scaledImage
    }
    
    @IBAction func tappedLogoutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            pushAccountSignupViewController()
        } catch let error {
            print("로그 아웃 error : \(error.localizedDescription)")
        }
        
    }
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil {
            pushAccountSignupViewController()
        }
    }
    
    private func pushAccountSignupViewController() {
        let storyboard = UIStoryboard(name: "AccountSignup", bundle: nil)
        let accountSignupViewController = storyboard.instantiateViewController(identifier: "AccountSignupViewController")
        let navigation = UINavigationController(rootViewController: accountSignupViewController)
        
        navigation.modalPresentationStyle = .fullScreen
        
        self.present(navigation, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tappedLogOutButton(_ sender: UIBarButtonItem) {
        print("Button : tappedLogOutButton")
    }
    
}



