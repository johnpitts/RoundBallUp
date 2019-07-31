//
//  Team.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/31/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation

struct Team: Codable {
    
    var id: String
    var name: String
    var market: String
    var alias: String
    var players: [TeamPlayer]
    
    
    struct TeamPlayer: Codable {
        
        var id: String
        var status: String
        var fullName: String
        var firstName: String
        var lastName: String
        var height: Int
        let position: String
        let primaryPosition: String
    }
}
