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

//Referencia dinamica al nodo principal de mi base de datos.
let DB_BASE_ROOT = Database.database().reference()

//Uso de una constante estatica para adoptar el patron Singleton.
class DataBaseService {
    
    static let instance = DataBaseService()
    
    //Referencia privada al nodo principal.
    private let _Base_Ref = DB_BASE_ROOT
    
    //Referencia privada al siguiente nodo despues del root, en el cual se colocaran los usuarios.
    //child es una funcion que recibe un String o pathString y retorna un objeto DatabaseReference.
    private let _User_Ref = DB_BASE_ROOT.child("users")
    
    //Encapsulamiento de variables
    var Base_Ref : DatabaseReference {
        
        //Retorna el valor de la variable privada.
        return _Base_Ref
    }
    
    var User_Ref : DatabaseReference {
        
        return _User_Ref
    }
    
    //Funcion que agrega y actualiza la informacion del usuario en la base de datos.
    //El parametro userData es un diccionario con toda la informacion del usuario.
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        
        //Se crea un nuevo nodo con los datos del usuario.
        User_Ref.child(uid).updateChildValues(userData)
    }
    
}
