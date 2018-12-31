//
//  LoginViewController.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 10/1/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginCopyLbl: UILabel!
    @IBOutlet weak var subLoginBtn: UIButton!
    
    var registerMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bindKeyboard()    //Activa la animacion de subir la vista unos frames mientras el teclado este presente.
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        //        self.view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        //Descarta la vista modal actual.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginActionBtn(_ sender: UIButton) {
        
        if (emailTextField.text == "" || passwordTextField.text == "") {
            
            self.showAlert(title: "Error", message: "Ingrese los datos")
            
        }else {
            
            //Unwrap de los campos email y password
            if let email = self.emailTextField.text {
                
                if let password = self.passwordTextField.text {
                    
                    //Si estoy en modo registro..
                    if registerMode {
                        
                        //Auth maneja la autentificacion en Firebase.
                        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                            
                            if error != nil {
                                
                                self.showAlert(title: "Error", message: error!.localizedDescription)
                            }else {
                                
                                print("La cuenta fue creada exitosamente")
                                
                                if let user = user {
                                    
                                    let userData = ["provider":user.providerID, "email":user.email!, "profileImage":"https://i.imgur.com/GbKyVIP.jpg", "displayName":"Crispeta"] as [String:Any]
                                    
                                    //Llamamos al singleton de la base de datos.
                                    DataBaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
                                }
                            }
                        })
                     
                     //Si el usuario ya existe...
                    }else {
                        
                        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                            
                            if error != nil {
                                
                                self.showAlert(title: "Error", message: error!.localizedDescription)
                            }else {
                                
                                print("Se hizo Login")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    )}
                }
            }
        }
    }
    
    //Funcion que crea una alerta.
    func showAlert(title: String, message: String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func subLoginActionBtn(_ sender: UIButton) {
       
        //Si estamos en modo registro, al hacer click en Login ingresamos al modo Login.
        if self.registerMode {
            
            self.loginBtn.setTitle("Login", for: .normal)
            self.loginCopyLbl.text = "Eres nuevo?"
            self.subLoginBtn.setTitle("SignUp", for: .normal)
            self.registerMode = false
        }else {
            
            self.loginBtn.setTitle("Crear Cuenta", for: .normal)
            self.loginCopyLbl.text = "Ya tienes cuenta?"
            self.subLoginBtn.setTitle("Login", for: .normal)
            self.registerMode = true
        }
    }
    
    //Metodo alternativo.
    //Cuando el teclado esta en la vista, se cierra si se detecta un toque en cualquier parte de la pantalla.
    //touchesBegan detecta si se produce un toque en la pantalla.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true);
    }
    
//    @objc func handleTap(sender: UITapGestureRecognizer) {
//
//        //endEditing cancela cualquier edicion que tengamos sobre la vista ¿??
//        self.view.endEditing(true)
//
//    }
}


