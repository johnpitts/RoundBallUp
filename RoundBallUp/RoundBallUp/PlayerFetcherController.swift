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
    
    var allTeams: [Heirarchy.Conference.Division.Team] = []      // i can't believe that worked!
    var allPlayers: [Player] = []
    
    var teamsDictionary: [ String : String ] = [:]
    var playersDictionary: [ String : String ] = [:]
    
    
    let baseURL = URL(string: "http://api.sportradar.us/nba/trial/v5/en/")!
    let apiKey = "dzb42xyudwxeaa4a9nxey5bg"
    typealias completionHandler = ()->Void
    
    
    func fetchTeamIDs(completion: @escaping completionHandler) {
        
        //URL Formatting:      ?? what is the difference between PathComponent and PathExtension?
        let heirarchyURL = baseURL.appendingPathComponent("league").appendingPathComponent("hierarchy").appendingPathExtension("json")
        var components = URLComponents(url: heirarchyURL, resolvingAgainstBaseURL: true)
        let keyQuery = URLQueryItem(name: "api_key", value: apiKey)
        components?.queryItems = [keyQuery]
        
        guard let url = components?.url else {
            NSLog("components of url failed to load properly")
            completion()
            return
        }
        
        //print("fetch URL: \n\(url)\n")
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) -> Void in
            
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
            
            //print(String(data: data, encoding: .utf8)!)      Don't erase, want to save this for future usage
            
            do {
                let decoder = JSONDecoder()
                let league = try decoder.decode(Heirarchy.self, from: data)
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Try HIGHER ORDER FUNCTIONS LATER: see code snippet below, commented-out
                for conference in league.conferences {
                    for division in conference.divisions {
                        for team in division.teams {
                            self.teamsDictionary[team.name] = team.id
                            self.allTeams.append(team)
                        }
                    }
                }
                for (key, value) in self.teamsDictionary {
                    print("\(key), \(value) ")
                }
                //print("allTeams: \(self.allTeams)")
                
            } catch let decodingError {
                NSLog("Error decoding data to Heirarchy model: \(decodingError)")
                completion()
            }
            completion()
            
        }.resume()
        // Assemble URL
    }

    
    // then call featchPlayers with all 30 team id to get all the player id
    func fetchPlayerIDs(completion: @escaping completionHandler) {
        
        // Loop thru all 30 teams, which requires changing the URL each time
        for team in teamsDictionary {
            
            // get players and player ids for one team
            let teamID = team.value
            let teamsURL = baseURL.appendingPathComponent("teams").appendingPathComponent(teamID).appendingPathComponent("profile").appendingPathExtension("json")
            var components = URLComponents(url: teamsURL, resolvingAgainstBaseURL: true)
            let keyQuery = URLQueryItem(name: "api_key", value: apiKey)
            components?.queryItems = [keyQuery]
            
            guard let url = components?.url else {
                NSLog("components of  playerID loader url failed to load properly")
                completion()
                return
            }
            
            print("fetch URL: \n\(url)\n")
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { (data, _, error) -> Void in
                
                if let error = error {
                    NSLog("Error URLSession dataTask fetching Player IDs \(error)")
                    completion()
                    return
                }
                guard let data = data else {
                    NSLog("Error data didn't exist")
                    completion()
                    return
                }
                
                print(String(data: data, encoding: .utf8)!)      //Don't erase, want to save this for future usage
                
                do {
                    let decoder = JSONDecoder()
                    let team = try decoder.decode([Player].self, from: data)
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    for player in team {
                        self.playersDictionary[player.fullName] = player.id
                        self.allPlayers.append(player)
                    }
                    for (key, value) in self.playersDictionary {
                        print("\(key), \(value) ")
                    }
                    print("\n")
                    print("allPlayers: \(self.allPlayers)")
                    
                } catch let decodingError {
                    NSLog("Error decoding data to PLAYER model: \(decodingError)")
                    completion()
                }
                completion()
                
                }.resume()
        } // end for-loop
        
        
    }
    
    
    func fetchOnePlayer(id: String) {
        
        // create URL using Player ID
        
        
        // fetch the player's stats and initiate the player using his name, placing him into storage array
        
    }
    
    
}





//     let bookings = activeDeals
//                .map { $0.bookings } // Gets the arrays of bookings
//                    .compactMap { $0 }   // Gets rid of the nils
//                    .flatMap { $0 }
