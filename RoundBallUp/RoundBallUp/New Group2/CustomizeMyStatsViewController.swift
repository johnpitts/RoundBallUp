//
//  CustomizeMyStatsViewController.swift
//  RoundBallUp
//
//  Created by John Pitts on 9/28/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class CustomizeMyStatsViewController: UIViewController {
    
    @IBOutlet weak var ptsCoeffTextField: UITextField!
    @IBOutlet weak var reboundsCoeffTextField: UITextField!
    @IBOutlet weak var stealsCoeffTextField: UITextField!
    @IBOutlet weak var blocksCoeffTextField: UITextField!
    @IBOutlet weak var assistsCoeffTextField: UITextField!
    @IBOutlet weak var turnoverCoeffTextField: UITextField!
    @IBOutlet weak var foulsCoeffTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveCustomStatModelTapped(_ sender: Any) {
        
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func perSelected(_ sender: Any) {
        //set the coefficients for each stat in textFields
        
        
    }
    
    @IBAction func bpmSelected(_ sender: Any) {
        
    }
    
    @IBAction func dbpmTapped(_ sender: Any) {
    }
    
    @IBAction func obpmTapped(_ sender: Any) {
    }
    
    @IBAction func winSharesTapped(_ sender: Any) {
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
