//
//  UserListViewController.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/02.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class UserListViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var userListTableView: UITableView!
    
    //var users: [User]?
    
    private var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
        
        userListTableView.register(UINib(nibName: "UserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "UserInfoTableViewCell")
        
        setupUi()
        confirmLoggedInUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchLoginUserInfo()
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
        
        self.userDataGetListFromFirbaseStore()
    }
    
    private func fetchLoginUserInfo() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userUid).getDocument { (snapshot, error) in
            if let error = error {
                print(" 파이어 베이스의 유저 정보 다운 로딩에 실패했습니다!.: \(error) ")
                return
            }
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            let user = User(dic: dic)
            self.user = user
            
            self.userListTableView.reloadData()
            
        }
    }
    
    private func userDataGetListFromFirbaseStore() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(currentUid)
        
        userRef.getDocument { (snapshot, error) in
            if let error = error {
                print(" 파이어 베이스의 유저 정보 도큐멘트 다운 로딩에 실패했습니다!.: \(error) ")
                return
            }
            let data = snapshot?.data()
            print("등록된 유저 리스트 : \(String(describing: data))")
        }
    }
    
    private func pushAccountSignupViewController() {
        let storyboard = UIStoryboard(name: "AccountSignup", bundle: nil)
        let accountSignupViewController = storyboard.instantiateViewController(identifier: "AccountSignupViewController")
        let navigation = UINavigationController(rootViewController: accountSignupViewController)
        
        navigation.modalPresentationStyle = .fullScreen
        
        self.present(navigation, animated: true, completion: nil)
    }
    

    
}


extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell") as? UserInfoTableViewCell else { return UITableViewCell() }
        cell.user = self.user
        return cell
    }
    
    
}

extension UserListViewController: UITableViewDelegate {
    
}

