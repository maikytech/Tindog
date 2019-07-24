//
//  UserModel.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 11/19/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import Foundation
import Firebase

//Model to control user data.

struct UserModel {
    
    let uid: String
    let email: String
    let provider: String
    let profileImage: String
    let displayName: String
    let usersIsOnMatch: Bool
    
    //DataSnapshot object return a snapshot of database.
    init?(snapshot: DataSnapshot){
        
        let uid = snapshot.key
        
        guard let dic = snapshot.value as? [String: String],
            let email = dic["email"] as? String,
            let provider = dic["provider"] as? String,
            let profileImage = dic["profileImage"] as? String,
            let displayName = dic["displayName"] as? String,
            let usersIsOnMatch = dic["usersIsOnMatch"] as? Bool else {
                return nil
        }
        
        self.uid = uid
        self.email = email
        self.provider = provider
        self.profileImage = profileImage
        self.displayName = displayName
        self.usersIsOnMatch = usersIsOnMatch
    }
}
