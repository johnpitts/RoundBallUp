//
//  PlayerDetailViewController.swift
//  RoundBallUp
//
//  Created by John Pitts on 8/1/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    
    var playerShown: Player? {
        didSet {
            updateViews()
        }
    }
    var playerFetcherController = PlayerFetcherController()
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var reboundsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var stealsLabel: UILabel!
    @IBOutlet weak var blocksLabel: UILabel!
    @IBOutlet weak var turnoversLabel: UILabel!
    @IBOutlet weak var foulsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        
        
        guard isViewLoaded,
            let playerShown = playerShown else { return }
        DispatchQueue.main.async {
            self.playerNameLabel.text = playerShown.fullName
            
            self.gradeLabel.text = "\(self.playerFetcherController.calculateCustomGrade(forThis: playerShown))"
            
            
            self.minutesLabel.text = "Minutes: \(playerShown.seasons[0].teams[0].total.minutes.truncate(0))"
            
            self.pointsLabel.text = "Points: \(playerShown.seasons[0].teams[0].total.points.truncate(0))"
            let ribbies = playerShown.seasons[0].teams[0].total.defensiveRebounds + playerShown.seasons[0].teams[0].total.offensiveRebounds
            self.reboundsLabel.text = "Rebounds: \(ribbies.truncate(0))"
            self.assistsLabel.text = "Assists: \(playerShown.seasons[0].teams[0].total.assists.truncate(0))"
            self.stealsLabel.text = "Steals: \(playerShown.seasons[0].teams[0].total.steals.truncate(0))"
            self.blocksLabel.text = "Blocks: \(playerShown.seasons[0].teams[0].total.blocks.truncate(0))"
            self.foulsLabel.text = "P.Fouls: \(playerShown.seasons[0].teams[0].total.personalFouls.truncate(0))"
            self.turnoversLabel.text = "Turnovers: \(playerShown.seasons[0].teams[0].total.turnovers.truncate(0))"
        }

        
        //pointsLabel.text = String(playerShown?.seasons[0].teams[0].total.points)
        // = playerShown.seasons[0].teams[0].total.fieldGoalsAtt.toString
        // = playerShown.seasons[0].teams[0].total.
        // = playerShown.seasons[0].teams[0].total.freeThrowsAtt.toString
    }
}

extension Double
{
    func truncate(_ places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

//extension Double {
//    func toString() -> String {
//        return String(format: "$.lf, self)
//    }
//}






/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
