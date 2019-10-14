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
    var teamsDictionary: [ String : String ] = [:]               // (team) name : id
    
    var allPlayers: [Team.TeamPlayer] = []
    var playersDictionary: [ String : String ] = [:]             // (player) fullName : id
    
    var playersToShow: [Player] = []
    
    private var persistentURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        print("File Manager Documents stored at: \(documents.path)")
        return documents.appendingPathComponent("players.plist")
    }
    
    let baseURL = URL(string: "http://api.sportradar.us/nba/trial/v5/en/")!
    let apiKey = "dzb42xyudwxeaa4a9nxey5bg"
    typealias completionHandler = ()->Void
    
    
    init() {
        //TO DO? this gets hit every time, but should probably only get hit once when the app first starts
        loadFromPersistentStore()
    }
    
    
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
            //print(String(data: data, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let league = try decoder.decode(Heirarchy.self, from: data)
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Try HIGHER ORDER FUNCTIONS LATER: see code snippet at bottom of file, commented-out
                for conference in league.conferences {
                    for division in conference.divisions {
                        for team in division.teams {
                            self.teamsDictionary[team.name] = team.id
                            self.allTeams.append(team)
                        }
                    }
                }
//                for (key, value) in self.teamsDictionary {
//                    print("\(key), \(value) ")
//                }
                //print("allTeams: \(self.allTeams)")
            } catch let decodingError {
                NSLog("Error decoding data to Heirarchy model: \(decodingError)")
                completion()
            }
            completion()
        }.resume()
    }

    
    func fetchPlayerIDs(completion: @escaping completionHandler) {
        // Use 30 team IDs to get 700+ Player IDs
        
        // Loop thru all 30 teams, which requires changing the URL each time
        for team in teamsDictionary {
            
            // get players / player ids for one team
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
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let team = try decoder.decode(Team.self, from: data)
                    
                    
                    let playersOnThisTeam = team.players
                    for player in playersOnThisTeam {
                        self.playersDictionary[player.fullName] = player.id
                        self.allPlayers.append(player)
                        
                        self.saveToPersistentStore()
                    }
//                    for (key, value) in self.playersDictionary {
//                        print("\(key), \(value) \n ")
//                    }
                    //print("allPlayers: \(self.allPlayers)")
                    
                } catch let decodingError {
                    NSLog("Error decoding data to PLAYER model: \(decodingError)")
                    completion()
                }
                completion()
                
                }.resume()
        } // end for-loop aka 30-teams
    }
    
    
    func fetchOnePlayer(id: String, completion: @escaping (Player?, Error?) -> Void) {
        
        // assembles a url from base + components + api key (query item)
        let playerURL = baseURL.appendingPathComponent("players").appendingPathComponent(id).appendingPathComponent("profile").appendingPathExtension("json")
        var components = URLComponents(url: playerURL, resolvingAgainstBaseURL: true)
        let keyQuery = URLQueryItem(name: "api_key", value: apiKey)
        components?.queryItems = [keyQuery]
        
        // converts url + queryItem components to url type, unless 'api key' wasn't present in which case we exit this network call before it starts
        guard let url = components?.url else {
            NSLog("components of  playerSTATS & BoxGrade loader url failed to load properly")
            completion(nil, nil)
            return
        }
        //print("fetch URL: \n\(url)\n")
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) -> Void in
            if let error = error {
                NSLog("Error URLSession dataTask fetching Player RoundballGrade STATS \(error)")
                completion(nil, error)
                return
            }
            guard let data = data else {
                NSLog("Error data didn't exist")
                completion(nil, error)
                return
            }
            //print(String(data: data, encoding: .utf8)!)      //Don't erase, want to save this for future usage
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let fetchedPlayer = try decoder.decode(Player.self, from: data)
                
                //print("\(fetchedPlayer.lastName) points: \(Double(fetchedPlayer.seasons[0].teams[0].total.points))")
                
                let customGrade = self.calculateCustomGrade(forThis: fetchedPlayer)
                print("...and his grade is: \(customGrade)\n")
                // initialize a player with added customGrade property, before saving to playersToShow
                
                self.playersToShow.append(fetchedPlayer)
                print(self.playersToShow)
                
                completion(fetchedPlayer, nil)
                
            } catch let decodingError {
                NSLog("Error decoding data to PLAYER model: \(decodingError)")
                completion(nil, error)
            }
        }.resume()
    }
    
    
    func calculateCustomGrade(forThis player: Player) -> String {    // will need to add season parameter later
        //typealias y18ft = seasons[0].teams[0].total
        // use a delegate method to getCustomStatCoeffecients
        let bCoeff = 0.5
        let aCoeff = 0.5
        let ftaCoeff = -0.5
        let pfCoeff = -0.5
        let rbVal = player.seasons[0].teams[0].total.defensiveRebounds + player.seasons[0].teams[0].total.offensiveRebounds
        let p = player.seasons[0].teams[0].total.points
        let a = player.seasons[0].teams[0].total.assists
        let s = player.seasons[0].teams[0].total.steals
        let pf = player.seasons[0].teams[0].total.personalFouls
        let tov = player.seasons[0].teams[0].total.turnovers
        let fga = player.seasons[0].teams[0].total.fieldGoalsAtt
        let min = player.seasons[0].teams[0].total.minutes
        let b = player.seasons[0].teams[0].total.blocks
        let fta = player.seasons[0].teams[0].total.freeThrowsAtt
        
        let rawGrade = (p + rbVal + s - tov - fga + (bCoeff * b) + (aCoeff * a) + (ftaCoeff * fta) + (pfCoeff * pf)) / min
        print("\(rawGrade) fga: \(fga)  fta: \(fta)")
        
        var grade = "n/a"
        switch rawGrade {
        case ..<0:
            grade = "F"
        case 0.000..<0.080:
            grade = "D"
        case 0.800..<1.200:
            grade = "C"
        case 0.120..<0.199:
            grade = "B"
        case 0.199..<0.249:
            grade = "A-"
        case 0.249..<0.300:
            grade = "A"
        case 0.300...:
            grade = "A+"
        default:
            grade = "n/a"
        }
        //if birthDate > 1995 ? return "\(grade)+" : return grade
        return grade
    }
    
    func saveToPersistentStore() {
        guard let url = persistentURL else { return }
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allPlayers)
            try data.write(to: url)
        } catch {
            NSLog("Error saving Players array")
        }
    }
    
    func loadFromPersistentStore() {
        let fileManager = FileManager.default
        
        guard let url = persistentURL,
            fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            allPlayers = try decoder.decode([Team.TeamPlayer].self, from: data)
        } catch {
            NSLog("Error loading data from disk... allPlayers array \(error)")
        }
    }
    
    
    
    
    
    // in the future we will want to get TEAM stats rather than player
    func getWholeTeam(id: String) {
        // filter results by team and present a UI the user can select to get a whole team's grades, but do this after you persist the data.
    }
    
    
}





//     let bookings = activeDeals
//                .map { $0.bookings } // Gets the arrays of bookings
//                    .compactMap { $0 }   // Gets rid of the nils
//                    .flatMap { $0 }
