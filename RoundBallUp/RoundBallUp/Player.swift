//
//  Player.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/29/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation


class Player: Codable {
    
    var id: String                     // sportRadar api lists it as GUID
    var fullName: String   // ie) Karl-Anthony Towns
    var firstName: String
    var lastName: String
    var seasons: [Year]     // for version 0.1 we will ALWAYS being using the 0th value, which is 2018 NBA Year
    
    struct Year: Codable {
        //let name: String           // ie) 2018, the json clearly shows this as an Int, so what gives?
        let teams: [Team]       // version 0.1 we will ALWAYS be using the 0th team, which is last team played during yr
        
        struct Team: Codable {
            let name: String
            let total: Total
            
            struct Total: Codable {
                var minutes: Double?
                var points: Double
                var offensiveRebounds: Double?
                var defensiveRebounds: Double?
                var steals: Double?
                var assists: Double?
                var blocks: Double?
                var turnovers: Double?
                var personalFouls: Double?
                
                var fieldGoalsMade: Double?
                var fieldGoalsAtt: Double?
                
                var freeThrowsMade: Double?
                var freeThrowsAtt: Double?
                
                //var scorePerMin: Double?
            }
    }
    
    
    
//    init(fullName: String, id: String, minutes: String, points: String, offensiveRebounds: String, defensiveRebounds: String, steals: String, assists: String, blocks: String, turnovers: String, personalFouls: String, fieldGoalsMade: String, fieldGoalsAtt: String, freeThrowsMade: String, freeThrowsAtt: String) {
//
//        self.fullName = fullName
//        self.id = id
//        self.minutes = Double(minutes)
//        self.points = Double(points)
//        self.offensiveRebounds = Double(offensiveRebounds)
//        self.defensiveRebounds = Double(defensiveRebounds)
//        self.steals = Double(steals)
//        self.assists = Double(assists)
//        self.blocks = Double(blocks)
//        self.turnovers = Double(turnovers)
//        self.personalFouls = Double(personalFouls)
//        self.fieldGoalsMade = Double(fieldGoalsMade)
//        self.fieldGoalsAtt = Double(fieldGoalsAtt)
//        self.freeThrowsMade = Double(freeThrowsMade)
//        self.freeThrowsAtt = Double(freeThrowsAtt)
        
        // convert everything to doubles
        //self.scorePerMin = ((points - fieldGoalsAtt - (0.5 * freeThrowsAtt) - (0.5 * personalFouls) + offensiveRebounds + defensiveRebounds + (0.5 * assists) + steals + (0.5 * blocks) - turnovers)) / 7.0 /*Double(minutes)*/
    }
}
