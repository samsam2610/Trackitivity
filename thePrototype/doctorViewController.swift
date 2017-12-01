//
//  doctorViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/26/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class doctorViewController: UIViewController {

    @IBOutlet weak var targetRep: UILabel!
    @IBOutlet weak var targetRag: UILabel!
    @IBOutlet weak var targetDur: UILabel!
    @IBOutlet weak var targetRepe: UISlider!
    @IBOutlet weak var targetTim: UISlider!
    @IBOutlet weak var targetRa: UISlider!
    
    override func viewDidLoad() {
        self.targetRep.text = "Target Repetitions is \(targetCount) counts"
        self.targetRag.text = "Target Range of Motion is \(targetROM) degrees"
        self.targetDur.text = "Target duration is \(targetTime) seconds"
        self.targetRepe.setValue(Float(targetCount), animated: false)
        self.targetRa.setValue(Float(targetROM), animated: false)
        self.targetTim.setValue(Float(targetTime), animated: false)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMain(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "backToMainFromDoctor", sender: UIBarButtonItem())
    }
    
    @IBAction func confirmSelection(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "The target ROM is \(targetROM), and the target repetitions is \(targetCount)", preferredStyle: .alert)
        
        // Create OK button with action handler
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "backToMainFromDoctor", sender: self)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            targetCount = 20
            targetROM = 40
            targetTime = 120
            self.targetRepe.setValue(Float(targetCount), animated: false)
            self.targetRa.setValue(Float(targetROM), animated: false)
            self.targetTim.setValue(Float(targetTime), animated: false)
            self.targetRep.text = "Target Repetitions is \(targetCount) counts"
            self.targetRep.text = "Target Repetitions is \(targetCount) counts"
            self.targetDur.text = "Target duration is \(targetTime) seconds"


        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(confirm)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)

    }
    
    @IBAction func targetRepetition(sender: UISlider ) {
        targetCount = Double(sender.value).rounded(toPlaces: 0)
        self.targetRep.text = "Target Repetitions is \(targetCount) counts"
        
    }
    
    @IBAction func targetRange(sender: UISlider) {
        targetROM = Double(sender.value).rounded(toPlaces: 0)
        self.targetRag.text = "Target ROM is \(targetROM) degrees"
    }
    
    @IBAction func targetDuration(sender: UISlider) {
        targetTime = Double(sender.value).rounded(toPlaces: 0)
        self.targetDur.text = "Target duration is \(targetTime) seconds"
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
