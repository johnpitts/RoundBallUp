//
//  PlayerTableViewController.swift
//  RoundBallUp
//
//  Created by John Pitts on 7/29/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class PlayerTableViewController: UITableViewController, UISearchBarDelegate {
    
    var playerFetcherController = PlayerFetcherController()
    var playersToShow: [Player]?
    var playerForDetail: Player?
    var filteredPlayers: [Team.TeamPlayer] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching: Bool = false                    //refactor to default value of false and you don't need the guard statements!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        if playerFetcherController.allPlayers.isEmpty {
          
            playerFetcherController.fetchTeamIDs {    // TEAM ID get FIRST, in order to...
                
                print("TEAM IDS FETCHED, commencing player ID fetch... \n")
                // CLOSURES ARE GREAT! for allowing a new procedure to come after a former one which takes time, in this case Player ID get is dependent on Team ID get, so closure allows Team ID fetch to finish before Player ID fetch begins
                
                self.playerFetcherController.fetchPlayerIDs { // ...in order to get Player IDs
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        print("players fetched \n")
                    }
                }
            }
        }
    }
    
    
    func getPlayerID(playerToSearch: String) -> String {
        return playerFetcherController.playersDictionary[playerToSearch] ?? "Karl-Anthony Towns"
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")
        
        if searchBar.text != "" {
            self.isSearching = true
            
            guard let playerToGrab = searchBar.text else { return }   // does searchBar need to be self/global too?
            //let playerToSearchID = getPlayerID(playerToSearch: playerToGrab)
            
            print("searched for: \(playerToGrab)")
            
            filteredPlayers = []
            filteredPlayers = playerFetcherController.allPlayers.filter({$0.fullName == playerToGrab || $0.firstName == playerToGrab || $0.lastName == playerToGrab})
            //print(filteredPlayers[0].fullName)
            
            self.tableView.reloadData()
  
        // This was used when searching was going to go right to the DetailVC
//            playerFetcherController.fetchOnePlayer(id: playerToSearchID) { (playerWithStats, error) in
//                if let error = error {
//                    NSLog("error fetching one player's stats: \(error)")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
        } else { isSearching = false; return }

        /* search for player or team in
        playerFetcherController.teamsDictionary
        playerFetcherController.playersDictionary
        
        if teamFound {
            self.tableView.reloadData() with players on team
        } else if playerFound {
            self.tableView.reloadData() with player
        } else {
            searchBar.placeholder = "Players/Teams not found, check for misspellings, typos & try again"
        } */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchBar.placeholder = "Enter player name" // or team"
        DispatchQueue.main.async {
            self.searchBar.text = ""
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        isSearching = false
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(playerFetcherController.allPlayers.count)
        print(filteredPlayers.count)
        
        if isSearching {
            isSearching = !isSearching
            return filteredPlayers.count
        } else {
            return playerFetcherController.allPlayers.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BallerCell", for: indexPath)
        
        if isSearching {
            let object = filteredPlayers[indexPath.row]
            cell.textLabel?.text = object.fullName
            return cell
        } else {
            let object = playerFetcherController.allPlayers[indexPath.row]
            cell.textLabel?.text = object.fullName
            return cell
        }
        //cell.detailTextLabel?.text = object.gradeScore   // can only be used when a new API is found
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerDetail" {
            guard let detailVC = segue.destination as? PlayerDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else  { return }
            
            let detailPlayerID: String
            if isSearching {
                detailPlayerID = filteredPlayers[indexPath.row].id
            } else {
                detailPlayerID = playerFetcherController.allPlayers[indexPath.row].id
            }
            
            playerFetcherController.fetchOnePlayer(id: detailPlayerID) { (playerForDetail, error) in
                if let error = error {
                    NSLog("error fetching one player's stats: \(error)")
                    return
                }
                self.playerForDetail = playerForDetail
                detailVC.playerShown = self.playerForDetail
            }  // end of fetch
        }
    }

    
}
