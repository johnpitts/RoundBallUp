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
    
    
    let baseURL = URL(string: "http://api.sportradar.us/nba/trial/v5/en/")!
    let apiKey = "dzb42xyudwxeaa4a9nxey5bg"
    
    
    
    func fetchTeams(completion: @escaping () -> Void) {
        
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
        
        print("fetch URL: \n\(url)\n")
        
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
                
                // parse the data into team ids which API requirs to fetch players
                print(league)
                // I think i'll need nested for loops, or nested compactMaps
//                for division in league.conferences.divisions {
//                    guard let team = division
//                }
                //     let bookings = activeDeals
//                .map { $0.bookings } // Gets the arrays of bookings
//                    .compactMap { $0 }   // Gets rid of the nils
//                    .flatMap { $0 }
                
                
            } catch let decodingError {
                NSLog("Error decoding data to Heirarchy model: \(decodingError)")
                completion()
            }
            
        }.resume()
        // Assemble URL
        
    }
        // call for heirarchy, break json down into conference, division, team to get team id
        // then call featchPlayers with all 30 team id to get all the player id
}
