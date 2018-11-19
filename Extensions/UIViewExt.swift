//
//  UIViewExt.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 10/10/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

//Generic extension to raise the view when the keyboard appears.

import Foundation
import UIKit

extension UIView{
    
    func bindKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardChange(_ notification: Notification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let frameBegin = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let frameEnd = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = frameEnd.origin.y - frameBegin.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
