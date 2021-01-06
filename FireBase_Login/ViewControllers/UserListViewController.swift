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
    }
    
    private func setupUi() {
        let image = UIImage(named: "exit")
        // 원하는 사이즈 적용
        let scaledImage = image?.resizeImage(size: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal)
        self.logOutButton.image = scaledImage
    }
    
    @IBAction func tappedLogOutButton(_ sender: UIBarButtonItem) {
        print("LOGOUT :")
    }
    
}



