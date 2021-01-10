//
//  AccountSignupViewController.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/02.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class AccountSignupViewController: UIViewController {
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var whenKeyboardShowConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.userNicknameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.userImageButton.addTarget(self, action: #selector(tappedUserImageButton), for: .touchUpInside)
        self.accountButton.addTarget(self, action: #selector(tappedAccountButton), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //키보드 상단 끝라인 위치와 어카운트 버턴의 하단 끝라인 위치를 뺀 값에 +20 저장후 트랜스 폼 Y위치 재설정
    @objc private func willShowKeyboard(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let accountButtonMaxY = accountButton.frame.maxY
        
        let distance = accountButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear) {
            self.view.transform = transform
        }
        //print("키보드 프레임의 상부 끝라인 :\(keyboardMinY) 어카운트 버턴의 하부 끝라인 :\(accountButtonMaxY)")
        //self.whenKeyboardShowConstraint.constant = 0
        
    }
    
    @objc private func willHideKeyboard(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear) {
            self.view.transform = .identity
        }
        //self.whenKeyboardShowConstraint.constant = 40
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
        
        let image = userImageButton.imageView?.image ?? UIImage(named: "chat_2")
        guard let uploadingImage = image?.jpegData(compressionQuality: 0.3) else { return }

        self.activityIndicator.startAnimating()
        
        let randomImageName = UUID.init().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(randomImageName)

        storageRef.putData(uploadingImage, metadata: nil) { (metadata, error) in
            if let error = error {
                print(" 파이어 베이스에 이미지 업로딩을 실패했습니다!.: \(error) ")
                self.activityIndicator.stopAnimating()
                return
            }

            print(" 파이어 베이스에 이미지를 업로딩 했습니다!. ")

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print(" 이미지 URL를 다운로딩하는데 실패했습니다!.: \(error) ")
                    self.activityIndicator.stopAnimating()
                    return
                }
                guard let urlString = url?.absoluteString else { return }
                print(" 이미지 경로를 다운로드 했습니다!. : \(urlString) ")

                self.creatUserAccountInfoToFireStore(url: urlString)
            }
        }
    }
    
    private func creatUserAccountInfoToFireStore(url: String) {
        guard let email = userEmailTextField.text else { return }
        guard let password = userPasswordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(" 파이어 베이스에 유저 등록을 실퍠 했습니다!.: \(error) ")
                self.activityIndicator.stopAnimating()
                return
            }
            print("회원 등록 성공 했습니다!")
            guard let uid = result?.user.uid else { return }
            guard let userName = self.userNicknameTextField.text else { return }
            
            self.userSetDataToFirebaseStore(email: email, uid: uid, username: userName)

        }
    }
    
    private func userSetDataToFirebaseStore(email: String, uid: String, username: String ) {

        let docData = [
            "email" : email,
            "name" : username,
            "creatAt" : Timestamp()
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                print(" 파이어 베이스에 유저 등록을 실퍠 했습니다!.: \(error) ")
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func tappedLoginButton() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}

// 이메일,패스워드,닉네임 다 채워지면 레지스터 이네이블하는 함수
/*
 *Nil-Coalescing Operator (Nil-통합 연산자)
 nil-통합 연산자 (nil-coalescing operator; a ?? b) 는 옵셔널 a 가 값을 담고 있으면 포장을 풀고, a 가 nil 이면 기본 값인 b 를 반환합니다. 표현식 a 는 항상 옵셔널 타입입니다. 표현식 b 는 반드시 a 에 저장된 값과 타입이 일치해야 합니다.
 */
extension AccountSignupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = userEmailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = userPasswordTextField.text?.isEmpty ?? false
        let nicknameIsEmpty = userNicknameTextField.text?.isEmpty ?? false
        
        if emailIsEmpty || passwordIsEmpty || nicknameIsEmpty {
            accountButton.isEnabled = false
            accountButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        }else {
            accountButton.isEnabled = true
            accountButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
        }
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

