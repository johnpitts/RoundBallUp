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
    var isSearching: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NBA Players"     //Why is this causing a constraint error??  conflicting with searchBar view?
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
        
        if searchBar.text != "" {
            self.isSearching = true
            
            guard let playerToGrab = searchBar.text else { return }
            //let playerToSearchID = getPlayerID(playerToSearch: playerToGrab)
            
            filteredPlayers = []
            filteredPlayers = playerFetcherController.allPlayers.filter({$0.fullName == playerToGrab || $0.firstName == playerToGrab || $0.lastName == playerToGrab})
            
            self.tableView.reloadData()
  
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
        
        DispatchQueue.main.async {
            self.searchBar.placeholder = "Enter player name" // or team"
            self.searchBar.text = ""
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // You will want to break all players down into team-sections when displayed
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableview reload: \(playerFetcherController.allPlayers.count)")
        
        if isSearching {
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
            cell.detailTextLabel?.text = object.primaryPosition
            return cell
        } else {
            let object = playerFetcherController.allPlayers[indexPath.row]
            cell.textLabel?.text = object.fullName
            cell.detailTextLabel?.text = object.primaryPosition
            return cell
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerDetail" {
            guard let detailVC = segue.destination as? PlayerDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else  { return }
            
            let detailPlayerID: String
            if isSearching {
                detailPlayerID = filteredPlayers[indexPath.row].id
                isSearching = !isSearching                              // does this go best here?
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
            }
        }
    }

    
}
