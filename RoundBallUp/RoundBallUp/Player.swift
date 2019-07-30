//
//  Player.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/29/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation

// decoder.keyDecodingStrategy = .convertFromSnakeCase

class Player {
    
    var fullName: String   // ie) Karl-Anthony Towns
    var id: String                     // sportRadar api lists it as GUID
    
    var minutes: Int
    var points: Int
    var offensiveRebounds: Int
    var defensiveRebounds: Int
    var steals: Int
    var assists: Int
    var blocks: Int
    var turnovers: Int
    var personalFouls: Int
    
    var fieldGoalsMade: Int
    var fieldGoalsAtt: Int
    
    var freeThrowsMade: Int
    var freeThrowsAtt: Int
    
    var scorePerMin: Double
    
    
    init(fullName: String, id: String, minutes: String, points: Int, offensiveRebounds: Int, defensiveRebounds: Int, steals: Int, assists: Int, blocks: Int, turnovers: Int, personalFouls: Int, fieldGoalsMade: Int, fieldGoalsAtt: Int, freeThrowsMade: Int, freeThrowsAtt: Int, scorePerMin: Double) {
        
        self.fullName = fullName
        self.id = id
        self.minutes = Double(minutes)
        self.points = points
        self.offensiveRebounds = offensiveRebounds
        self.defensiveRebounds = defensiveRebounds
        self.steals = steals
        self.assists = assists
        self.blocks = blocks
        self.turnovers = turnovers
        self.personalFouls = personalFouls
        self.fieldGoalsMade = fieldGoalsMade
        self.fieldGoalsAtt = fieldGoalsAtt
        self.freeThrowsMade = freeThrowsMade
        self.freeThrowsAtt = freeThrowsAtt
        
        self.scorePerMin = (points - fieldGoalsAtt - 0.5*freeThrowsAtt - 0.5*personalFouls + offensiveRebounds + defensiveRebounds + 0.5*assists + steals + 0.5 * blocks - turnovers)/Double(minutes)
    }
}
