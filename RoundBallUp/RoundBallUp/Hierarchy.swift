//
//  Hierarchy.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/29/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation

struct Heirarchy: Codable {
    //var league: [String: String ]       Do no delete, for potential future use, but not used for current app version 0.1
    var conferences: [Conference]
    
    struct Conference: Codable {
        let divisions: [Division]
        
        struct Division: Codable {
            let teams: [Team]
            
            struct Team: Codable {
                let name: String
                let id: String
            }
        }
    }
}
