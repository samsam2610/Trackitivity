//
//  ExerciseViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/24/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    let animals = ["Panda", "Lion", "Elefant"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (animals.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExerciseTableViewCell
        
        cell.demoImage.image = UIImage(named: (animals[indexPath.row] + ".jpg"))
        cell.demoInfo.text = animals[indexPath.row]
        
        return (cell)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
