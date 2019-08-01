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
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        playerFetcherController.fetchTeamIDs {    // TEAM ID get FIRST, in order to...
            
            print("TEAM IDS FETCHED, commencing player ID fetch... \n")
            // CLOSURES ARE GREAT! for allowing a new procedure to come after a former one which takes time, in this case Player ID get is dependent on Team ID get, so closure allows Team ID fetch to finish before Player ID fetch begins

            self.playerFetcherController.fetchPlayerIDs { // ...PLAYER ID get NEXT.
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
            
            guard let playerToGrab = searchBar.text else { return }
            let playerToSearchID = getPlayerID(playerToSearch: playerToGrab)
            
            playerFetcherController.fetchOnePlayer(id: playerToSearchID) { (playersToShow, error) in
                if let error = error {
                    NSLog("error fetching one player's stats: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else { return }

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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
       //   searchBar.placeholder = "Enter Player or Team to get BoxGrade"
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(playerFetcherController.allTeams.count)
        return playerFetcherController.allPlayers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BallerCell", for: indexPath)
        
        let object = playerFetcherController.allPlayers[indexPath.row]

        cell.textLabel?.text = object.fullName
        //cell.detailTextLabel?.text = object.id

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
