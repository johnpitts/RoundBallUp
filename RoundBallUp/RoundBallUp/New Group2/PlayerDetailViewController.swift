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
            
            self.minutesLabel.text = "Minutes: \(Int(playerShown.seasons[0].teams[0].total.minutes))"
            
            self.pointsLabel.text = "Points: \(Int(playerShown.seasons[0].teams[0].total.points))"
            let ribbies = playerShown.seasons[0].teams[0].total.defensiveRebounds + playerShown.seasons[0].teams[0].total.offensiveRebounds
            self.reboundsLabel.text = "Rebounds: \(Int(ribbies))"
            self.assistsLabel.text = "Assists: \(Int(playerShown.seasons[0].teams[0].total.assists))"
            self.stealsLabel.text = "Steals: \(Int(playerShown.seasons[0].teams[0].total.steals))"
            self.blocksLabel.text = "Blocks: \(Int(playerShown.seasons[0].teams[0].total.blocks))"
            self.foulsLabel.text = "P.Fouls: \(Int(playerShown.seasons[0].teams[0].total.personalFouls))"
            self.turnoversLabel.text = "Turnovers: \(Int(playerShown.seasons[0].teams[0].total.turnovers))"
        }

        //
        //pointsLabel.text = String(playerShown?.seasons[0].teams[0].total.points)
        // = playerShown.seasons[0].teams[0].total.fieldGoalsAtt.toString
        // = playerShown.seasons[0].teams[0].total.
        // = playerShown.seasons[0].teams[0].total.freeThrowsAtt.toString
    }
}

extension Double  {
    func truncate(_ places : Int)-> Double  {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

//extension Double {
//    func toString() -> String {
//        return String(format: "$.lf, self)
//    }
//}

