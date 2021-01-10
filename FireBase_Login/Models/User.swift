//
//  User.swift
//  FireBase_Login
//
//  Created by 이용석 on 2021/01/10.
//

import Foundation
import Firebase

class User {
    let email: String
    let name: String
    let creatAt: Timestamp
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.creatAt = dic["creatAt"] as? Timestamp ?? Timestamp()
    }
}
