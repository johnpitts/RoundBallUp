//
//  Hierarchy.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/29/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation

struct League {
    var conferences: [Division]
    
    struct Division {
        let teams: [Team]
        
        struct Team {
            let name: String
            let id: String
        }
    }
}
