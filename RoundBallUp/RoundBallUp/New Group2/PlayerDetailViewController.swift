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
            
            self.gradeLabel.text = "\(self.playerFetcherController.calculateCustomGrade(forThis: playerShown))"   // fix with guard let
            
            //self.minutesLabel.text = playerShown.seasons[0].teams[0].total.minutes
//            self.pointsLabel.text = playerShown.seasons[0].teams[0].total.points.toString()
//            //reboundsLabel.text = ((playerShown?.seasons[0].teams[0].total.defensiveRebounds)! + (playerShown?.seasons[0].teams[0].total.offensiveRebounds)!).toString()               //not sure why I need ! solution
//            self.assistsLabel.text = playerShown.seasons[0].teams[0].total.assists.toString()
//            self.stealsLabel.text = playerShown.seasons[0].teams[0].total.steals.toString()
//            self.blocksLabel.text = playerShown.seasons[0].teams[0].total.blocks.toString()
//            self.foulsLabel.text = playerShown.seasons[0].teams[0].total.personalFouls.toString()
            self.turnoversLabel.text = "\(playerShown.seasons[0].teams[0].total.turnovers)"
        }

        
        //pointsLabel.text = String(playerShown?.seasons[0].teams[0].total.points)
        // = playerShown.seasons[0].teams[0].total.fieldGoalsAtt.toString
        // = playerShown.seasons[0].teams[0].total.
        // = playerShown.seasons[0].teams[0].total.freeThrowsAtt.toString
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
