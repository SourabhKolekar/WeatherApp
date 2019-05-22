//
//  FavoriteCell.swift
//  weatherApp
//
//  Created by Sourabh on 23/5/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    //outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureFavCell(temp:Int, Location:String)
    {
    
        self.locationLabel.text = Location
        
    }
    
}
