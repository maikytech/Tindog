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

class DataBaseService {
    
    //Uso de una constante estatica para adoptar el patron Singleton.
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
    
    //Funcion que consulta el perfil del usuario y verifica si existen cambios en el perfil.
    //los closure tipo @escaping se ejecutan asincronicamente, es decir, cuando la funcion ya esta retornando los valores finales o por fuera de la funcion.
    //El handler retorna un objeto de tipo UserModel.
    func observeUserProfile(handler: @escaping(_ userProfileDict: UserModel?) -> Void){
        
        //Accedemos al usuario actual.
        if let currentUser = Auth.auth().currentUser {
            
            //Se crea una instancia de clase el cual es el singleton, para acceder al nodo de usuarios y a su vez al uid.
            //observe es una funcion que se utiliza para "observar" cambios en un determinado nodo de la base de datos.
            //El parametro .value significa que observe escuchara cualquier cambio.
            //El siguiente parametro es un closure que nos retorna la informacion del usuario a traves de la variable snapshot.
            DataBaseService.instance.User_Ref.child(currentUser.uid).observe(.value, with: {(snapshot) in
                
                //Se parsean los datos del snapshot en userDict, y los casteamos a tipos de datos UserModel llamando al constructor de la estructura.
                if let userDict = UserModel(snapshot: snapshot) {
                    
                    //Se llama al handler con la informacion recopilada en userDict.
                    handler(userDict)
                }
            })
        }
    }
}
