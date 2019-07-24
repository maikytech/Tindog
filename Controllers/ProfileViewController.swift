//
//  ProfileViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 10/22/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileDisplayNameLbl: UILabel!
    @IBOutlet weak var profileEmailLbl: UILabel!
    
     var currentUserProfile: UserModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.profileImageConfig()
    }
    
    func profileImageConfig() {
        
        self.profileImage.sd_setImage(with: URL(string: (self.currentUserProfile?.profileImage)!), completed: nil)
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 1.0
        self.profileImage.clipsToBounds = true
        self.profileDisplayNameLbl.text = currentUserProfile?.displayName
        self.profileEmailLbl.text = currentUserProfile?.email
    }
    
    @IBAction func closeProfileBtn(_ sender: Any) {
        
        try! Auth.auth().signOut()
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func ImportUsersAction(_ sender: UIButton) {
        
        
    }
}
