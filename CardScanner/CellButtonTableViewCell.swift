//
//  CellButtonTableViewCell.swift
//  CardScanner
//
//  Created by Frontend on 25/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class CellButtonTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var labelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
