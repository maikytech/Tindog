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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileDisplayNameLbl: UILabel!
    @IBOutlet weak var profileEmailLbl: UILabel!
    
     var currentUserProfile: UserModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.profileImageConfig()
    }
    
    func profileImageConfig() {
        
        //Genera un cuadro con la puntas redondeadas de acuerdo al radio, en este caso, sera un circulo.
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        
        //cgColor es el tipo de color a nivel de layer.
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        
        self.profileImage.layer.borderWidth = 1.0
        
        //Corta las esquinas sobrantes.
        self.profileImage.clipsToBounds = true
    }
    
    @IBAction func closeProfileBtn(_ sender: Any) {
        
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
}
