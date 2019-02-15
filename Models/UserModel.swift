//
//  UserModel.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 11/19/18.
//  Copyright © 2018 PosetoStudio. All rights reserved.
//

import Foundation
import Firebase

//Estructura para el manejo de la informacion del usuario.

struct UserModel {
    
    let uid: String
    let email: String
    let provider: String
    let profileImage: String
    let displayName: String
    
    //Un objeto de tipo DataSnapshot es una instantanea de los usuarios con la informacion que se tiene en la base de datos de Firebase.
    init?(snapshot: DataSnapshot){
        
        let uid = snapshot.key
        
        //Condicional tipo guard, permite utilizar las variables locales fuera del condicional.
        //Si alguna variable dentro del guard no se puede asignar por alguna razon, a traves del else, le asignamos el valor nil a esa variable.
        //dic es un diccionario que recibe la info de los usuarios de la variable snapshot
        guard let dic = snapshot.value as? [String: String],
            let email = dic["email"] as? String,
            let provider = dic["provider"] as? String,
            let profileImage = dic["profileImage"] as? String,
            let displayName = dic ["displayName"] as? String
        
        else {
            
                //Retorna nil para que el objeto no quede incompleto en caso de que falte algun dato.
                return nil
        }
        
        self.uid = uid
        self.email = email
        self.provider = provider
        self.profileImage = profileImage
        self.displayName = displayName
        
    }
}
