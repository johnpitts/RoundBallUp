//
//  PlayerFetcherController.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/29/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation

class PlayerFetcherController {
    
    // PROPERTIES:
    
    var players: [Player] = []
    
    var teams: [League.Division.Team] = []      // i can't believe that worked!
    
    
    let baseURL: String = "http://api.sportradar.us/nba/trial/v5/en/"
    let sportRadarAPIKey = "dzb42xyudwxeaa4a9nxey5bg"
    
    
    func fetchTeams() {
    
    // call for heirarchy, break json down into conference, division, team to get team id
    // Assemble URL
    // Grab Player objects using URLSession.shared.dataTask
    
    
    // then call featchPlayers with all 30 team id to get all the player id
    }
    
    
    
    
    
    
    
}
