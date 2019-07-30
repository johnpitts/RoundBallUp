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
    
    var allTeams: [League.Division.Team] = []      // i can't believe that worked!
    
    
    let baseURL = URL(string: "http://api.sportradar.us/nba/trial/v5/en/")!
    let sportRadarAPIKey: String = "api_key=dzb42xyudwxeaa4a9nxey5bg"
    
    
    
    func fetchTeams(completion: @escaping () -> Void) {
        
        let heirarchyURL = baseURL.appendingPathComponent("league/heirarchy")
        
        let url = heirarchyURL.appendingPathExtension(".json?\(sportRadarAPIKey)")
        print(url)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching team heirarchy \(error)")
                completion()
                return
            }
            guard let data = data else {
                NSLog("Error data didn't exist")
                completion()
                return
            }
            do {
                let decoder = JSONDecoder()
                let league = try decoder.decode(
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            
        }.resume()
        // Assemble URL
        
    }
        // call for heirarchy, break json down into conference, division, team to get team id
        // then call featchPlayers with all 30 team id to get all the player id
}
