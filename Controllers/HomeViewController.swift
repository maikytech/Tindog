//
//  HomeViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 9/21/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit
import RevealingSplashView          //A Splash view that animates and reveals its content, inspired by the Twitter splash.
import Firebase

//Class to configure the Image tittle.
class NavigationImageView: UIImageView {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return CGSize(width: 76, height: 39)
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var homeWrapper: UIStackView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var nopeImage: UIImageView!
    @IBOutlet weak var cardProfileImage: UIImageView!
    @IBOutlet weak var cardProfileName: UILabel!
    
    let loginButton = UIButton(type: .custom)
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "splash_icon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    var currentUserProfile: UserModel?
    var seconUserUid : String?
    
    //List of database users.
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.launchScreenConfig(revealingSplashView: revealingSplashView)
        self.tittleViewConfig()
        self.UIGestureConfig()
        self.buttonLoginConfig(leftBtn: loginButton)
        self.observeData()
    }
    
    func launchScreenConfig(revealingSplashView: RevealingSplashView) {
        
        self.view.addSubview(revealingSplashView)
        self.revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        self.revealingSplashView.startAnimation()
    }
    
    //Manual creation of the tittle image of app.
    func tittleViewConfig() {
        
        let tittleView = NavigationImageView()
        tittleView.image = UIImage(named: "Actions")
        self.navigationItem.titleView = tittleView
    }
    
    //Configuration of the gesture of sliding the image
    func UIGestureConfig() {
        
        let homeGR = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(gestureRecognizer:)))
        self.cardView.addGestureRecognizer(homeGR)
    }
    
    @objc func cardDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let cardPoint = gestureRecognizer.translation(in: view)
        self.cardView.center = CGPoint(x: self.view.bounds.width / 2 + cardPoint.x, y: self.view.bounds.height / 2 + cardPoint.y)
        let xFromCenter = self.view.bounds.width / 2 - self.cardView.center.x
        var rotate = CGAffineTransform(rotationAngle: xFromCenter / 500)
        let scale = min(100 / abs(xFromCenter), 1)
        var finalTransform = rotate.scaledBy(x: scale, y: scale)
        
        self.cardView.transform = finalTransform
        
        //Si es Like o disLike...
        if self.cardView.center.x < self.view.bounds.width / 2 - 100 {
            
            self.nopeImage.alpha = min(abs(xFromCenter) / 100, 1)
            self.likeImage.alpha = 0
        }
        
        if self.cardView.center.x > self.view.bounds.width / 2 + 100 {
            
            self.likeImage.alpha = min(abs(xFromCenter) / 100, 1)
            self.nopeImage.alpha = 0
        }
        
        if gestureRecognizer.state == .ended {
            
            if self.cardView.center.x < self.view.bounds.width / 2 - 100 {
                
                print("it isn´t like")
            }
            
            if self.cardView.center.x > self.view.bounds.width / 2 + 100 {
                
                print("it´s like")
                
                if let uid2 = self.seconUserUid{
                    
                    DataBaseService.instance.createFirebaseBDMatch(uid: self.currentUserProfile!.uid, uid2: uid2)
                }
            }
            
            rotate = CGAffineTransform(rotationAngle: 0)
            finalTransform = rotate.scaledBy(x: 1, y: 1)
            self.cardView.transform = finalTransform
            self.likeImage.alpha = 0
            self.nopeImage.alpha = 0
            self.cardView.center = CGPoint(x: self.homeWrapper.bounds.width / 2, y: self.homeWrapper.bounds.height / 2 - 30)
            
            if self.users.count > 0 {
                
                //It does not matter whether the user matches or not, the screen is refreshed.
                self.updateImage(uid: self.users[self.random(0..<self.users.count)].uid)
            }
        }
    }
    
    //Returns an integer from the number of users.
    func random(_ range: Range<Int>) -> Int{
        
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    //Manual creation of Login button
    func buttonLoginConfig(leftBtn: UIButton) {
        
        self.loginButton.imageView?.contentMode = .scaleAspectFit
        let leftBarButton = UIBarButtonItem(customView: self.loginButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func observeData() {
        
        //Listens if the user login or logout.
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("El usuario inicio correctamente")
            }else{
                print("Logout")
            }
            
            //observer starts listening when the user or the database has changes
            DataBaseService.instance.observeUserProfile {(userDict) in
                self.currentUserProfile = userDict
            }
            
            self.getUsers()
        }
        
        UpdateDBService.instance.observeMatch { (matchDict) in
            
            print("Update match")
        }
    }
    
    func getUsers() {
        
        //Observe any change just one time
        DataBaseService.instance.User_Ref.observeSingleEvent(of: .value) { (snapshot) in
            
            //The first element of the snapshot is accessed.
            let userSnapshot = snapshot.children.compactMap{UserModel(snapshot: $0 as! DataSnapshot)}
            
            if userSnapshot.count > 0 {
                
                for user in userSnapshot{
                    
                    print("Los usuarios son: \(user.email)")
                    self.users.append(user)
                }
            }
            
            //If the app finds at least one user, it updates the HomeView
            if self.users.count > 0{
                
                self.updateImage(uid: (self.users.first?.uid)!)
            }
        }
    }
    
    func updateImage(uid: String){
        
        DataBaseService.instance.User_Ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let userProfile = UserModel(snapshot: snapshot){
                
                self.seconUserUid = userProfile.uid
                self.cardProfileImage.sd_setImage(with: URL(string: userProfile.profileImage), completed: nil)
                self.cardProfileName.text = userProfile.displayName
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loginModalViewConfig(leftBtn: loginButton)
    }
    
    func loginModalViewConfig(leftBtn: UIButton) {
        
        if Auth.auth().currentUser != nil {
            
            self.loginButton.setImage(UIImage(named: "login_active"), for: .normal)
            self.loginButton.removeTarget(nil, action: nil, for: .allEvents)
            self.loginButton.addTarget(self, action: #selector(goToProfile(sender:)), for: .touchUpInside)
            
        }else {
            
            self.loginButton.setImage(UIImage(named: "login"), for: .normal)
            self.loginButton.removeTarget(nil, action: nil, for: .allEvents)
            self.loginButton.addTarget(self, action: #selector(goToLogin(sender:)), for: .touchUpInside)
        }
    }
    
    //Configuration of modal view of pofile.
    @objc func goToProfile(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        profileViewController.currentUserProfile = self.currentUserProfile
        //present(profileViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    //Configuration of modal view of Login.
    @objc func goToLogin(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        present(loginViewController, animated: true, completion: nil)
    }
}
