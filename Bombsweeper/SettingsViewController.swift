//
//  SettingsViewController.swift
//  Bombsweeper
//
//  Created by HPro2 on 1/30/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var size = 10
    
    @IBOutlet weak var boardSizeLabel: UILabel!
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBAction func boardSizeStepper(_ sender: UIStepper) {
        size = Int(sender.value)
        boardSizeLabel.text = "Board Size: \(size)"
    }

    @IBOutlet weak var colorPicker: UIColorWell!
    override func viewDidLoad() {
        super.viewDidLoad()
        stepperOutlet.value = 10
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
