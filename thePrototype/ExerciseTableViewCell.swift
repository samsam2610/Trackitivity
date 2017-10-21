//
//  ExerciseTableViewCell.swift
//  thePrototype
//
//  Created by Tran Sam on 9/24/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var demoName: UILabel!
    @IBOutlet weak var demoImage: UIImageView!
    @IBOutlet weak var demoInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        demoInfo.font = demoInfo.font.withSize(15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
