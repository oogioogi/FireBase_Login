//
//  AccountSignupViewController.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/02.
//

import UIKit

class AccountSignupViewController: UIViewController {
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        
        self.userImageButton.addTarget(self, action: #selector(tappedUserImageButton), for: .touchUpInside)
        self.accountButton.addTarget(self, action: #selector(tappedAccountButton), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUi() {
        
        self.userImageButton.setImage(UIImage(named: "chat_2"), for: .normal)
        self.userImageButton.layer.cornerRadius = 75
        self.userImageButton.layer.borderWidth = 1
        self.userImageButton.clipsToBounds = true
        self.userImageButton.layer.borderColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1).cgColor
        
        self.accountButton.layer.cornerRadius = 15
        self.loginButton.layer.cornerRadius = 15
    }
    
    @objc private func tappedUserImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func tappedAccountButton() {
        print("회원 등록: ")
    }
    
    @objc private func tappedLoginButton() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}


// MARK: - UIImagePickerControllerDelegate,UINavigationControllerDelegate
// 사진 편집후 동그란 원에 넣음.
extension AccountSignupViewController: UINavigationControllerDelegate {

}

extension AccountSignupViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editImage = info[.editedImage] as? UIImage {
            userImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            userImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        userImageButton.setTitle("", for: .normal)
        userImageButton.imageView?.contentMode = .scaleAspectFill
        userImageButton.contentVerticalAlignment = .fill
        userImageButton.contentHorizontalAlignment = .fill
        userImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)

    }
}

