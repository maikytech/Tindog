//
//  ProfileViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 10/22/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBAction func closeProfileBtn(_ sender: Any) {
        
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
}
