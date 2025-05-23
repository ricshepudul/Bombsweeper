//
//  StartViewController.swift
//  Bombsweeper
//
//  Created by HPro2 on 1/29/25.
//

import UIKit

class StartViewController: UIViewController {
    
    var size = 10
    var color = UIColor.lightGray
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            let viewController = segue.destination as! ViewController
            viewController.boardSize = size
            viewController.color = self.color
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let settingsViewController = segue.source as! SettingsViewController
        self.size = settingsViewController.size
        self.color = settingsViewController.colorPicker.selectedColor ?? UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
