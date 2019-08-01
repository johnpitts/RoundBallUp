//
//  PlayerDetailViewController.swift
//  RoundBallUp
//
//  Created by John Pitts on 8/1/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    
    var playerShown: Player?
    
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

        minutesLabel.text = playerShown?.seasons[0].teams[0].total.minutes.toString()
        pointsLabel.text = playerShown?.seasons[0].teams[0].total.points.toString()
        reboundsLabel.text = ((playerShown?.seasons[0].teams[0].total.defensiveRebounds)! + (playerShown?.seasons[0].teams[0].total.offensiveRebounds)!).toString()               //not sure why I need ! solution
        assistsLabel.text = playerShown?.seasons[0].teams[0].total.assists.toString()
        stealsLabel.text = playerShown?.seasons[0].teams[0].total.steals.toString()
        blocksLabel.text = playerShown?.seasons[0].teams[0].total.blocks.toString()
        foulsLabel.text = playerShown?.seasons[0].teams[0].total.personalFouls.toString()
        turnoversLabel.text = playerShown?.seasons[0].teams[0].total.turnovers.toString()
        
        //pointsLabel.text = String(playerShown?.seasons[0].teams[0].total.points)
        // = playerShown.seasons[0].teams[0].total.fieldGoalsAtt.toString
        // = playerShown.seasons[0].teams[0].total.
        // = playerShown.seasons[0].teams[0].total.freeThrowsAtt.toString
    }
}

extension Double {
    func toString() -> String {
        return String(format: "$.1f", self)
    }
}






/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
