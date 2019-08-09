//
//  DataBaseService.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 10/14/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

//Singleton for database creation

import Foundation
import Firebase

let DB_BASE_ROOT = Database.database().reference()

class DataBaseService {
    
    static let instance = DataBaseService()
    private let _Base_Ref = DB_BASE_ROOT
    private let _User_Ref = DB_BASE_ROOT.child("users")
    private let _Match_Ref = DB_BASE_ROOT.child("match")

    var Base_Ref : DatabaseReference {
        
        return _Base_Ref
    }
    
    var User_Ref : DatabaseReference {
        
        return _User_Ref
    }
    
    var Match_Ref : DatabaseReference{
        
        return _Match_Ref
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        
        User_Ref.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseBDMatch(uid: String, uid2: String){
        
        Match_Ref.child(uid).updateChildValues(["uid2":uid2, "matchIsAccepted":false])
    }
    
    //Observe change in DB
    func observeUserProfile(handler: @escaping(_ userProfileDict: UserModel?) -> Void){
        
        if let currentUser = Auth.auth().currentUser {
            
            DataBaseService.instance.User_Ref.child(currentUser.uid).observe(.value, with: {(snapshot) in
                
                if let userDict = UserModel(snapshot: snapshot) {
                    
                    handler(userDict)
                }
            })
        }
    }
}
