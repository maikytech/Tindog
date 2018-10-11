//
//  LoginViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 10/1/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func closeBtn(_ sender: UIButton) {
        
        //Descarta la vista modal.
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.bindKeyboard()    //Activa la animacion de subir la vista unos frames mientras el teclado este presente.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        //endEditing cancela cualquier edicion que tengamos sobre la vista ¿??
        self.view.endEditing(true)
        
    }
}


