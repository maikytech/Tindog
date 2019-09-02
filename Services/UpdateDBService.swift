//
//  UpdateDBService.swift
//  Tindog
//
//  Created by Maiqui Cedeño on 8/9/19.
//  Copyright © 2019 PosetoStudio. All rights reserved.
//

import Foundation
import Firebase

class UpdateDBService {
    
    static let instance = UpdateDBService()
    
    func observeMatch(handler: @escaping(_ matchDict: MatchModel?) -> Void){
        
        DataBaseService.instance.Match_Ref.observe(.value) {(snapshot) in
            
            if let matchSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                if matchSnapshot.count > 0{
                    
                    for match in matchSnapshot{
                        
                        if match.hasChild("uid") && match.hasChild("matchIsAccepted"){
                            
                            if let matchDict = MatchModel(snapshot: match){
                                
                                handler(matchDict)
                            }
                        }
                    }
                } else{
                    
                    handler(nil)
                }
            }
        }
    }
}
